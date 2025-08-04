# opinionated module that can be used to build nixos images with
# a dm-verity protected nix store
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.image.repart.verityStore;

  verityMatchKey = "store";

  # TODO: make these and other arch mappings available from systemd-lib for example
  partitionTypes = {
    nix-store =
      {
        "x86_64" = "83df5f3c-3378-484c-b61a-eb6035de90c1";
        "arm64" = "dd7c5f84-7f48-484e-945c-bc8067417ab2";
      }
      ."${pkgs.stdenv.hostPlatform.linuxArch}";

    nix-store-verity =
      {
        "x86_64" = "6c190700-0c79-4e3b-b010-f370fc989f01";
        "arm64" = "247d5fbc-a73d-4940-a416-4b8b16788eaf";
      }
      ."${pkgs.stdenv.hostPlatform.linuxArch}";
  };

  verityHashCheck =
    pkgs.buildPackages.writers.writePython3Bin "assert_uki_repart_match.py"
      {
        flakeIgnore = [ "E501" ]; # ignores PEP8's line length limit of 79 (black defaults to 88 characters)
      }
      (
        builtins.replaceStrings
          [ "@NIX_STORE_VERITY@" ]
          [
            partitionTypes.nix-store-verity
          ]
          (builtins.readFile ./assert_uki_repart_match.py)
      );
in
{
  options.image.repart.verityStore = {
    enable = lib.mkEnableOption "building images with a dm-verity protected nix store";

    ukiPath = lib.mkOption {
      type = lib.types.str;
      default = "/EFI/Linux/${config.system.boot.loader.ukiFile}";
      defaultText = "/EFI/Linux/\${config.system.boot.loader.ukiFile}";
      description = ''
        Specify the location on the ESP where the UKI is placed.
      '';
    };

    partitionIds = {
      esp = lib.mkOption {
        type = lib.types.str;
        default = "00-esp";
        description = ''
          Specify the attribute name of the ESP.
        '';
      };
      store-verity = lib.mkOption {
        type = lib.types.str;
        default = "10-store-verity";
        description = ''
          Specify the attribute name of the store's dm-verity hash partition.
        '';
      };
      store = lib.mkOption {
        type = lib.types.str;
        default = "20-store";
        description = ''
          Specify the attribute name of the store partition.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd = {
      systemd.dmVerity.enable = true;
      nix-store-veritysetup.enable = true;
      supportedFilesystems = {
        ${config.image.repart.partitions.${cfg.partitionIds.store}.repartConfig.Format} =
          lib.mkDefault true;
      };
    };

    image.repart.partitions = {
      # dm-verity hash partition
      ${cfg.partitionIds.store-verity}.repartConfig = {
        Type = partitionTypes.nix-store-verity;
        Verity = "hash";
        VerityMatchKey = lib.mkDefault verityMatchKey;
        Label = lib.mkDefault "store-verity";
      };
      # dm-verity data partition that contains the nix store
      ${cfg.partitionIds.store} = {
        stripNixStorePrefix = true;
        storePaths = [ config.system.build.toplevel ];
        repartConfig = {
          Type = partitionTypes.nix-store;
          Verity = "data";
          Format = lib.mkDefault "erofs";
          VerityMatchKey = lib.mkDefault verityMatchKey;
          Label = lib.mkDefault "store";
        };
      };
    };

    fileSystems = {
      "/" = lib.mkDefault {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [ "mode=0755" ];
      };
      "/nix/store" = lib.mkImageMediaOverride {
        device = "/dev/mapper/nix-store";
        fsType = "erofs";
      };
    };
    system.build = {

      # intermediate system image without ESP
      intermediateImage =
        (config.system.build.image.override {
          # always disable compression for the intermediate image
          compression.enable = false;
        }).overrideAttrs
          (
            _: previousAttrs: {
              # make it easier to identify the intermediate image in build logs
              pname = "${previousAttrs.pname}-intermediate";

              # do not prepare the ESP, this is done in the final image
              systemdRepartFlags = previousAttrs.systemdRepartFlags ++ [ "--defer-partitions=esp" ];
            }
          );

      # UKI with embedded storehash from intermediateImage
      uki =
        let
          inherit (config.system.boot.loader) ukiFile;
          cmdline = "init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}";
        in
        # override the default UKI
        lib.mkOverride 99 (
          pkgs.runCommand ukiFile
            {
              nativeBuildInputs = [
                pkgs.jq
                pkgs.systemdUkify
              ];
            }
            ''
              mkdir -p $out

              # Extract the storehash from the output of the systemd-repart invocation for the intermediate image.
              storehash=$(jq -r \
                '.[] | select(.type=="${partitionTypes.nix-store-verity}") | .roothash' \
                ${config.system.build.intermediateImage}/repart-output.json
              )

              # Build UKI with the embedded storehash.
              ukify build \
                  --config=${config.boot.uki.configFile} \
                  --cmdline="${cmdline} storehash=$storehash" \
                  --output="$out/${ukiFile}"
            ''
        );

      # final system image that is created from the intermediate image by injecting the UKI from above
      finalImage =
        (config.system.build.image.override {
          # continue building with existing intermediate image
          createEmpty = false;
        }).overrideAttrs
          (
            finalAttrs: previousAttrs: {
              # add entry to inject UKI into ESP
              finalPartitions = lib.recursiveUpdate previousAttrs.finalPartitions {
                ${cfg.partitionIds.esp}.contents = {
                  "${cfg.ukiPath}".source = "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
                };
              };

              nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
                pkgs.systemdUkify
                verityHashCheck
                pkgs.jq
              ];

              preBuild = ''
                # check that we build the final image with the same intermediate image for
                # which the injected UKI was built by comparing the UKI cmdline with the repart output
                # of the intermediate image
                #
                # This is necessary to notice incompatible substitutions of
                # non-reproducible store paths, for example when working with distributed
                # builds, or when offline-signing the UKI.
                ukify --json=short inspect ${config.system.build.uki}/${config.system.boot.loader.ukiFile} \
                  | assert_uki_repart_match.py "${config.system.build.intermediateImage}/repart-output.json"

                # copy the uncompressed intermediate image, so that systemd-repart picks it up
                cp -v ${config.system.build.intermediateImage}/${config.image.repart.imageFileBasename}.raw .
                chmod +w ${config.image.repart.imageFileBasename}.raw
              '';

              # replace "TBD" with the original roothash values
              preInstall = ''
                mv -v repart-output{.json,_orig.json}

                jq --slurp --indent -1 \
                  '.[0] as $intermediate | .[1] as $final
                    | $intermediate | map(select(.roothash != null) | { "uuid":.uuid,"roothash":.roothash }) as $uuids
                    | $final + $uuids
                    | group_by(.uuid)
                    | map(add)
                    | sort_by(.offset)' \
                      ${config.system.build.intermediateImage}/repart-output.json \
                      repart-output_orig.json \
                  > repart-output.json

                rm -v repart-output_orig.json
              '';
            }
          );
    };
  };

  meta.maintainers = with lib.maintainers; [
    nikstur
    willibutz
  ];
}
