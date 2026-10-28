{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
  versionCheckHook,
  callPackage,
  makeWrapper,
  symlinkJoin,
  stdenv,
}:

let
  # Fetch official CloudQuery plugin from the cloudquery repository
  fetchOfficialPlugin = lib.makeOverridable (
    {
      pluginType,
      pluginName,
      version,
      hash,
      tag ? "plugins-${pluginType}-${pluginName}-v${version}",
    }:
    fetchFromGitHub {
      owner = "cloudquery";
      repo = "cloudquery";
      inherit hash tag;
    }
  );

  # Build a CloudQuery plugin using buildGoModule with extendMkDerivation
  buildOfficialPlugin = lib.extendMkDerivation {
    constructDrv = buildGoModule;

    extendDrvArgs =
      finalAttrs:
      {
        pluginType,
        pluginName,
        version,
        vendorHash,
        src,
        sourceRoot ? "source/plugins/${pluginType}/${pluginName}",
        subPackages ? [ "." ],
        preBuild ? "",
        postInstall ? "",
        doCheck ? false,
        meta ? { },
        ...
      }@prevAttrs:
      {
        pname = "cloudquery-${pluginType}-${pluginName}";
        inherit
          version
          vendorHash
          doCheck
          src
          sourceRoot
          subPackages
          preBuild
          ;

        ldflags = [
          "-s"
          "-w"
          "-X github.com/cloudquery/cloudquery/plugins/${pluginType}/${pluginName}/resources/plugin.Version=${version}"
        ];

        postInstall = ''
          mv $out/bin/${pluginName} $out/bin/cloudquery-${pluginType}-${pluginName}
          rm -f $out/bin/gen
        ''
        + postInstall;

        meta = {
          description = "CloudQuery ${pluginType} plugin for ${pluginName}";
          homepage = "https://github.com/cloudquery/cloudquery";
          license = lib.licenses.mpl20;
        }
        // meta;
      };
  };
in
lib.makeOverridable (
  finalAttrs:
  buildGoModule (cliAttrs: {
    pname = "cloudquery";
    version = "6.43.0";
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "cloudquery";
      repo = "cloudquery";
      tag = "v${cliAttrs.version}";
      hash = "sha256-wTuMBiKjvG4bfH3gSIjG9cV6dsZ4Vn1QuLeiHTZT+qM=";
    };

    modRoot = "cli";

    vendorHash = "sha256-F8iQmZ0n/rPmcDO+3SNLC4s4CRB/0HA45pGM+Nf6g2g=";

    subPackages = [
      "."
    ];

    ldflags = [
      "-s"
      "-w"
      "-X github.com/cloudquery/cloudquery/cli/v${lib.versions.major cliAttrs.version}/cmd.Version=${cliAttrs.version}"
    ];

    doInstallCheck = true;

    nativeBuildInputs = [
      installShellFiles
      versionCheckHook
    ];

    postInstall = ''
      mv $out/bin/cli $out/bin/cloudquery

      installShellCompletion --cmd cloudquery \
         --bash <($out/bin/cloudquery completion bash) \
         --fish <($out/bin/cloudquery completion fish) \
         --zsh <($out/bin/cloudquery completion zsh)
    '';

    passthru = {
      updateScript = nix-update-script { };
      inherit buildOfficialPlugin fetchOfficialPlugin;
      # Plugin namespace for easy access
      plugins = {
        sources = callPackage ./plugins/sources.nix { inherit buildOfficialPlugin fetchOfficialPlugin; };
        destinations = callPackage ./plugins/destinations.nix {
          inherit buildOfficialPlugin fetchOfficialPlugin;
        };
      };
      # Wrap cloudquery with a set of plugins, making them available in PATH
      # Usage: pkgs.cloudquery.withPlugins [ pkgs.cloudquery.plugins.sources.aws ]
      withPlugins =
        plugins:
        let
          pluginList = if lib.isList plugins then plugins else lib.attrValues plugins;
          pluginDir = symlinkJoin {
            name = "cloudquery-plugins";
            paths = pluginList;
          };
        in
        stdenv.mkDerivation {
          pname = "cloudquery-with-plugins";
          inherit (cliAttrs) version;
          inherit pluginDir;
          dontUnpack = true;

          nativeBuildInputs = [ makeWrapper ];

          installPhase = ''
            mkdir -p $out/bin
            makeWrapper "${cliAttrs.finalPackage}/bin/cloudquery" $out/bin/cloudquery \
              --set NIX_CQ_PLUGINS "$pluginDir/bin"
          '';

          meta = cliAttrs.meta // {
            description = "${cliAttrs.meta.description} (with bundled plugins)";
          };
        };
      # Test validate-config with bundled plugins
      tests = {
        validate-config =
          let
            awsPlugin = cliAttrs.passthru.plugins.sources.aws;
            postgresPlugin = cliAttrs.passthru.plugins.destinations.postgresql;
            pluginDir = symlinkJoin {
              name = "cloudquery-test-plugins";
              paths = [
                awsPlugin
                postgresPlugin
              ];
            };
            configYaml = builtins.toFile "cloudquery-test-config.yaml" ''
              kind: source
              spec:
                name: aws
                path: "''${NIX_CQ_PLUGINS}/cloudquery-source-aws"
                registry: local
                tables: ["aws_s3_buckets"]
                destinations: ["postgresql"]
              ---
              kind: destination
              spec:
                name: postgresql
                path: "''${NIX_CQ_PLUGINS}/cloudquery-destination-postgresql"
                registry: local
                spec:
                  connection_string: "postgres://localhost/test"
            '';
          in
          stdenv.mkDerivation {
            pname = "cloudquery-validate-config-test";
            inherit (cliAttrs) version;
            dontUnpack = true;

            buildPhase = ''
              echo "Validating CloudQuery config with AWS source and PostgreSQL destination..."
              export NIX_CQ_PLUGINS="${pluginDir}/bin"
              "${cliAttrs.finalPackage}/bin/cloudquery" validate-config ${configYaml}
            '';

            installPhase = ''
              mkdir -p $out
              touch $out/success
            '';

            meta = {
              description = "Test cloudquery config validation";
            };
          };
      };
    };

    meta = {
      description = "Data pipelines for cloud config and security data";
      homepage = "https://github.com/cloudquery/cloudquery";
      changelog = "https://github.com/cloudquery/cloudquery/releases/tag/${cliAttrs.src.tag}";
      license = lib.licenses.mpl20;
      maintainers = with lib.maintainers; [
        jlesquembre
        jherland
      ];
      mainProgram = "cloudquery";
    };
  })
) { }
