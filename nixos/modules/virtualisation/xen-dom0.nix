# Xen hypervisor (Dom0) support.

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.virtualisation.xen;

  xenBootBuilderPath = "${
    pkgs.writeShellApplication {
      name = "xenBootBuilder";
      runtimeInputs = builtins.attrValues {
        inherit (pkgs)
          bat
          binutils
          coreutils
          diffutils
          findutils
          gawk
          gnugrep
          gnused
          jq
          systemdMinimal
          ;
      };
      text =
        # Set the EFI mount point from the config attribute.
        ''
          shopt -s nullglob
          efiMountPoint=${config.boot.loader.efi.efiSysMountPoint}
        ''
        # Handle input argument and exit if the flag is invalid. See virtualisation.xen.efi.bootBuilderFlag below.
        + ''
          [[ $# -ne 1 ]] && echo -e "\e[1;31merror:\e[0m xenBootBuilder must be called with exactly one argument. See the \e[1;34mvirtualisation.xen.efi.bootBuilderFlag\e[0m internal option." && exit 1
          case "$1" in
              "--quiet") true ;;
              "--release"|"--report") echo "Installing Xen Hypervisor boot entries..." ;;
              "--debug") echo -e "\e[1;34mxenBootBuilder:\e[0m called with the '$1' flag" ;;
               *) echo -e "\e[1;31merror:\e[0m xenBootBuilder was called with an invalid argument. See the \e[1;34mvirtualisation.xen.efi.bootBuilderFlag\e[0m internal option."; exit 2
          esac
        ''
        # Get the current Xen generations and store them in an array. This will be used
        # for displaying the diff later, if xenBootBuilder was called with `--report`.
        # We also delete the current Xen entries here, as they'll be rebuilt later if
        # the corresponding NixOS generation still exists.
        + ''
          mapfile -t preGenerations < <(find "$efiMountPoint"/loader/entries -type f -name 'xen-*.conf' | sort -V | sed 's/\/loader\/entries\/nixos/\/loader\/entries\/xen/g' | sed 's/^.*\/xen/xen/g' | sed 's/.conf$//g')
          if [ "$1" = "--debug" ]; then
              if (( ''${#preGenerations[@]} == 0 )); then
                  echo -e "\e[1;34mxenBootBuilder:\e[0m no previous Xen entries."
              else
                  echo -e "\e[1;34mxenBootBuilder:\e[0m deleting the following stale xen entries:" && for debugGen in "''${preGenerations[@]}"; do echo "                - $debugGen"; done
              fi
          fi
          rm -f "$efiMountPoint"/{loader/entries/xen-*.conf,efi/nixos/xen-*.efi}
        ''
        # Main array for storing which generations exist in $efiMountPoint after
        # systemd-boot-builder.py builds the main entries.
        + ''
          mapfile -t gens < <(find "$efiMountPoint"/loader/entries -type f -name 'nixos-*.conf' | sort -V)
          [ "$1" = "--debug" ] && echo -e "\e[1;34mxenBootBuilder:\e[0m found the following NixOS boot entries:" && for debugGen in "''${gens[@]}"; do echo "                - $debugGen"; done
        ''
        # This is the main loop that installs the Xen entries.
        + ''
          for gen in "''${gens[@]}"; do
        ''
        # We discover the path to Bootspec through the init attribute in the entries,
        # as it is equivalent to $toplevel/init.
        + ''
          bootspecFile="$(sed -nr 's/^options init=(.*)\/init.*$/\1/p' "$gen")/boot.json"
          [ "$1" = "--debug" ] && echo -e "\e[1;34mxenBootBuilder:\e[0m processing bootspec file $bootspecFile"
        ''
        # We do nothing if the Bootspec for the current $gen does not contain the Xen
        # extension, which is added as a configuration attribute below.
        + ''
          if grep -sq '"org.xenproject.bootspec.v1"' "$bootspecFile"; then
              [ "$1" = "--debug" ] && echo -e "                \e[1;32msuccess:\e[0m found Xen entries in $gen."
        ''
        # TODO: Support DeviceTree booting. Xen has some special handling for DeviceTree
        # attributes, which will need to be translated in a boot script similar to this
        # one. Having a DeviceTree entry is rare, and it is not always required for a
        # successful boot, so we don't fail here, only warn with `--debug`.
        + ''
          if grep -sq '"devicetree"' "$bootspecFile"; then
              echo -e "\n\e[1;33mwarning:\e[0m $gen has a \e[1;34morg.nixos.systemd-boot.devicetree\e[0m Bootspec entry. Xen currently does not support DeviceTree, so this value will be ignored in the Xen boot entries, which may cause them to \e[1;31mfail to boot\e[0m."
          else
              [ "$1" = "--debug" ] && echo -e "\e[1;34mxenBootBuilder:\e[0m no DeviceTree entries found in $gen."
          fi
        ''
        # Prepare required attributes for `xen.cfg/xen.conf`. It inherits the name of
        # the corresponding nixos generation, substituting `nixos` with `xen`:
        # `xen-$profile-generation-$number-specialisation-$specialisation.{cfg,conf}`
        + ''
          xenGen=$(echo "$gen" | sed 's/\/loader\/entries\/nixos/\/loader\/entries\/xen/g' | sed 's/^.*\/xen/xen/g' | sed 's/.conf$//g')
          bootParams=$(jq -re '."org.xenproject.bootspec.v1".xenParams | join(" ")' "$bootspecFile")
          kernel=$(jq -re '."org.nixos.bootspec.v1".kernel | sub("^/nix/store/"; "") | sub("/bzImage"; "-bzImage.efi")' "$bootspecFile")
          kernelParams=$(jq -re '."org.nixos.bootspec.v1".kernelParams | join(" ")' "$bootspecFile")
          initrd=$(jq -re '."org.nixos.bootspec.v1".initrd | sub("^/nix/store/"; "") | sub("/initrd"; "-initrd.efi")' "$bootspecFile")
          init=$(jq -re '."org.nixos.bootspec.v1".init' "$bootspecFile")
          title=$(sed -nr 's/^title (.*)$/\1/p' "$gen")
          version=$(sed -nr 's/^version (.*)$/\1/p' "$gen")
          machineID=$(sed -nr 's/^machine-id (.*)$/\1/p' "$gen")
          sortKey=$(sed -nr 's/^sort-key (.*)$/\1/p' "$gen")
        ''
        # Write `xen.cfg` to a temporary location prior to UKI creation.
        + ''
          tmpCfg=$(mktemp)
          [ "$1" = "--debug" ] && echo -ne "\e[1;34mxenBootBuilder:\e[0m writing $xenGen.cfg to temporary file..."
          cat > "$tmpCfg" << EOF
          [global]
          default=xen

          [xen]
          options=$bootParams
          kernel=$kernel root=fstab init=$init $kernelParams
          ramdisk=$initrd
          EOF
          [ "$1" = "--debug" ] && echo -e "done."
        ''
        # Create Xen UKI for $generation. Most of this is lifted from
        # https://xenbits.xenproject.org/docs/unstable/misc/efi.html.
        + ''
          [ "$1" = "--debug" ] && echo -e "\e[1;34mxenBootBuilder:\e[0m making Xen UKI..."
          xenEfi=$(jq -re '."org.xenproject.bootspec.v1".xen' "$bootspecFile")
          padding=$(objdump --header --section=".pad" "$xenEfi" | awk '/\.pad/ { printf("0x%016x\n", strtonum("0x"$3) + strtonum("0x"$4))};')
          [ "$1" = "--debug" ] && echo "               - padding: $padding"
          objcopy \
              --add-section .config="$tmpCfg" \
              --change-section-vma .config="$padding" \
              "$xenEfi" \
              "$efiMountPoint"/EFI/nixos/"$xenGen".efi
          [ "$1" = "--debug" ] && echo -e "               - \e[1;32msuccessfully built\e[0m $xenGen.efi"
          rm -f "$tmpCfg"
        ''
        # Write `xen.conf`.
        + ''
          [ "$1" = "--debug" ] && echo -ne "\e[1;34mxenBootBuilder:\e[0m writing $xenGen.conf to EFI System Partition..."
          cat > "$efiMountPoint"/loader/entries/"$xenGen".conf << EOF
          title $title (with Xen Hypervisor)
          version $version
          efi /EFI/nixos/$xenGen.efi
          machine-id $machineID
          sort-key $sortKey
          EOF
          [ "$1" = "--debug" ] && echo -e "done."
        ''
        # Sometimes, garbage collection weirdness causes a generation to still exist in
        # the loader entries, but its Bootspec file was deleted. We consider such a
        # generation to be invalid, but we don't write extra code to handle this
        # situation, as supressing grep's error messages above is quite enough, and the
        # error message below is still technically correct, as no Xen can be found in
        # something that does not exist.
        + ''
          else
              [ "$1" = "--debug" ] && echo -e "                \e[1;33mwarning:\e[0m \e[1;31mno Xen found\e[0m in $gen."
          fi
          done
        ''
        # Clean up unused Xen Hypervisors.
        + ''
          bootctl cleanup 2> /dev/null
        ''
        # Counterpart to the preGenerations array above. We use it to diff the
        # generations created/deleted when callled with the `--report` argument.
        + ''
          mapfile -t postGenerations < <(find "$efiMountPoint"/loader/entries -type f -name 'xen-*.conf' | sort -V | sed 's/\/loader\/entries\/nixos/\/loader\/entries\/xen/g' | sed 's/^.*\/xen/xen/g' | sed 's/.conf$//g')
        ''
        # In the event the script does nothing, guide the user to debug, as it'll only
        # ever run when Xen is enabled, and it makes no sense to enable Xen and not have
        # any hypervisor boot entries.
        + ''
          if (( ''${#postGenerations[@]} == 0 )); then
              case "$1" in
                  "--release"|"--report") echo "none found." && echo -e "If you believe this is an error, set the \e[1;34mvirtualisation.xen.efi.bootBuilderFlag\e[0m internal option to \e[1;34m\"--debug\"\e[0m and rebuild to print debug logs." ;;
                  "--debug") echo -e "\e[1;34mxenBootBuilder:\e[0m wrote \e[1;31mno generations\e[0m. Most likely, there were no generations with a valid \e[1;34morg.xenproject.bootspec.v1\e[0m entry." ;;
              esac
        ''
        # If the script is successful, change the default boot, say "done.", write a
        # diff, or print the total files written, depending on the argument this script
        # was called with. We use some dumb dependencies here, like `bat` for
        # colourisation, but they don't run with the default `release` argument.
        #
        # It's fine to change the default here, as this runs after the
        # `systemd-boot-builder.py` script, which overwrites the file, and this script
        # does not run after an user disables the Xen module.
        + ''
          else
              sed --in-place 's/^default nixos-/default xen-/g' "$efiMountPoint"/loader/loader.conf
              case "$1" in
                  "--release"|"--report") echo "done." ;;
                  "--debug") echo -e "\e[1;34mxenBootBuilder:\e[0m \e[1;32msuccessfully wrote\e[0m the following generations:" && for debugGen in "''${postGenerations[@]}"; do echo "                - $debugGen"; done ;;
              esac
              if [ "$1" = "--report" ]; then
                  if [[ ''${#preGenerations[@]} == "''${#postGenerations[@]}" ]]; then
                      echo -e "\e[1;33mNo Change:\e[0m Xen Hypervisor boot entries were refreshed, but their contents are identical."
                  else
                      echo -e "\e[1;32mSuccess:\e[0m Changed the following boot entries:"
                      diff <(echo "''${preGenerations[*]}" | tr ' ' '\n') <(echo "''${postGenerations[*]}" | tr ' ' '\n') -U 0 | grep --invert-match --extended-regexp '^(@@|---|\+\+\+).*' | bat --language diff --plain --theme ansi
                  fi
              fi
          fi
        '';
    }
  }/bin/xenBootBuilder";
in

{
  imports = with lib.modules; [
    (mkRemovedOptionModule
      [
        "virtualisation"
        "xen"
        "bridge"
        "name"
      ]
      "The Xen Network Bridge options are currently unavailable. Please set up your own bridge manually."
    )
    (mkRemovedOptionModule
      [
        "virtualisation"
        "xen"
        "bridge"
        "address"
      ]
      "The Xen Network Bridge options are currently unavailable. Please set up your own bridge manually."
    )
    (mkRemovedOptionModule
      [
        "virtualisation"
        "xen"
        "bridge"
        "prefixLength"
      ]
      "The Xen Network Bridge options are currently unavailable. Please set up your own bridge manually."
    )
    (mkRemovedOptionModule
      [
        "virtualisation"
        "xen"
        "bridge"
        "forwardDns"
      ]
      "The Xen Network Bridge options are currently unavailable. Please set up your own bridge manually."
    )
    (mkRenamedOptionModule
      [
        "virtualisation"
        "xen"
        "qemu-package"
      ]
      [
        "virtualisation"
        "xen"
        "qemu"
        "package"
      ]
    )
    (mkRenamedOptionModule
      [
        "virtualisation"
        "xen"
        "package-qemu"
      ]
      [
        "virtualisation"
        "xen"
        "qemu"
        "package"
      ]
    )
    (mkRenamedOptionModule
      [
        "virtualisation"
        "xen"
        "stored"
      ]
      [
        "virtualisation"
        "xen"
        "store"
        "path"
      ]
    )
    (mkRenamedOptionModule
      [
        "virtualisation"
        "xen"
        "storePath"
      ]
      [
        "virtualisation"
        "xen"
        "store"
        "path"
      ]
    )
  ];

  ###### interface

  options = {

    virtualisation.xen = {

      enable = lib.options.mkEnableOption "the Xen Hypervisor, a virtualisation technology defined as a *type-1 hypervisor*, which allows multiple virtual machines, known as *domains*, to run concurrently on the physical machine. NixOS runs as the privileged *Domain 0*. This option requires a reboot into a Xen kernel to take effect";

      trace = lib.options.mkEnableOption "Xen debug tracing and logging for Domain 0";

      debug = lib.options.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Whether to enable Xen debug features for Domain 0. This option enables some hidden debugging tests and features, and should not be used in production.";
      };

      package = lib.options.mkOption {
        type = lib.types.package;
        default = pkgs.xen;
        defaultText = lib.options.literalExpression "pkgs.xen";
        example = lib.options.literalExpression "pkgs.xen-slim";
        description = ''
          The package used for Xen Hypervisor.
        '';
        relatedPackages = [
          "xen"
          "xen-slim"
        ];
      };

      qemu = {
        package = lib.options.mkOption {
          type = lib.types.package;
          default = pkgs.xen;
          defaultText = lib.options.literalExpression "pkgs.xen";
          example = lib.options.literalExpression "pkgs.qemu_xen";
          description = ''
            The package with QEMU binaries that runs in Domain 0
            and virtualises the unprivileged domains.
          '';
          relatedPackages = [
            "xen"
            {
              name = "qemu_xen";
              comment = "For use with `pkgs.xen-slim`.";
            }
          ];
        };
        pidFile = lib.options.mkOption {
          type = lib.types.path;
          default = "/run/xen/qemu-dom0.pid";
          example = "/var/run/xen/qemu-dom0.pid";
          description = "Path to the QEMU PID file.";
        };
      };

      store = {
        path = lib.options.mkOption {
          type = lib.types.path;
          default = "${cfg.package}/bin/oxenstored";
          defaultText = lib.options.literalExpression "\${config.virtualisation.xen.package}/bin/oxenstored";
          example = lib.options.literalExpression "\${config.virtualisation.xen.package}/bin/xenstored";
          description = ''
            Path to the Xen Store Daemon. This option is useful to
            switch between the legacy C-based Xen Store Daemon, and
            the newer OCaml-based Xen Store Daemon, `oxenstored`.
          '';
        };
        type = lib.options.mkOption {
          type = lib.types.enum [
            "c"
            "ocaml"
          ];
          default = if (lib.strings.hasSuffix "oxenstored" cfg.store.path) then "ocaml" else "c";
          internal = true;
          readOnly = true;
          description = "Helper internal option that determines the type of the Xen Store Daemon based on cfg.store.path.";
        };
        settings = lib.options.mkOption {
          default = { };
          example = {
            enableMerge = false;
            quota.maxWatchEvents = 2048;
            quota.enable = true;
            conflict.maxHistorySeconds = 0.12;
            conflict.burstLimit = 15.0;
            xenstored.log.file = "/dev/null";
            xenstored.log.level = "info";
          };
          description = ''
            The OCaml-based Xen Store Daemon configuration. This
            option does nothing with the C-based `xenstored`.
          '';
          type = lib.types.submodule {
            options = {
              pidFile = lib.options.mkOption {
                default = "/run/xen/xenstored.pid";
                example = "/var/run/xen/xenstored.pid";
                type = lib.types.path;
                description = "Path to the Xen Store Daemon PID file.";
              };
              testEAGAIN = lib.options.mkOption {
                default = cfg.debug;
                defaultText = lib.options.literalExpression "config.virtualisation.xen.debug";
                example = true;
                type = lib.types.bool;
                internal = true;
                description = "Randomly fail a transaction with EAGAIN. This option is used for debugging purposes only.";
              };
              enableMerge = lib.options.mkOption {
                default = true;
                example = false;
                type = lib.types.bool;
                description = "Whether to enable transaction merge support.";
              };
              conflict = {
                burstLimit = lib.options.mkOption {
                  default = 5.0;
                  example = 15.0;
                  type = lib.types.addCheck (
                    lib.types.float
                    // {
                      name = "nonnegativeFloat";
                      description = "nonnegative floating point number, meaning >=0";
                      descriptionClass = "nonRestrictiveClause";
                    }
                  ) (n: n >= 0);
                  description = ''
                    Limits applied to domains whose writes cause other domains' transaction
                    commits to fail. Must include decimal point.

                    The burst limit is the number of conflicts a domain can cause to
                    fail in a short period; this value is used for both the initial and
                    the maximum value of each domain's conflict-credit, which falls by
                    one point for each conflict caused, and when it reaches zero the
                    domain's requests are ignored.
                  '';
                };
                maxHistorySeconds = lib.options.mkOption {
                  default = 5.0e-2;
                  example = 1.0;
                  type = lib.types.addCheck (
                    lib.types.float // { description = "nonnegative floating point number, meaning >=0"; }
                  ) (n: n >= 0);
                  description = ''
                    Limits applied to domains whose writes cause other domains' transaction
                    commits to fail. Must include decimal point.

                    The conflict-credit is replenished over time:
                    one point is issued after each conflict.maxHistorySeconds, so this
                    is the minimum pause-time during which a domain will be ignored.
                  '';
                };
                rateLimitIsAggregate = lib.options.mkOption {
                  default = true;
                  example = false;
                  type = lib.types.bool;
                  description = ''
                    If the conflict.rateLimitIsAggregate option is `true`, then after each
                    tick one point of conflict-credit is given to just one domain: the
                    one at the front of the queue. If `false`, then after each tick each
                    domain gets a point of conflict-credit.

                    In environments where it is known that every transaction will
                    involve a set of nodes that is writable by at most one other domain,
                    then it is safe to set this aggregate limit flag to `false` for better
                    performance. (This can be determined by considering the layout of
                    the xenstore tree and permissions, together with the content of the
                    transactions that require protection.)

                    A transaction which involves a set of nodes which can be modified by
                    multiple other domains can suffer conflicts caused by any of those
                    domains, so the flag must be set to `true`.
                  '';
                };
              };
              perms = {
                enable = lib.options.mkOption {
                  default = true;
                  example = false;
                  type = lib.types.bool;
                  description = "Whether to enable the node permission system.";
                };
                enableWatch = lib.options.mkOption {
                  default = true;
                  example = false;
                  type = lib.types.bool;
                  description = ''
                    Whether to enable the watch permission system.

                    When this is set to `true`, unprivileged guests can only get watch events
                    for xenstore entries that they would've been able to read.

                    When this is set to `false`, unprivileged guests may get watch events
                    for xenstore entries that they cannot read. The watch event contains
                    only the entry name, not the value.
                    This restores behaviour prior to [XSA-115](https://xenbits.xenproject.org/xsa/advisory-115.html).
                  '';
                };
              };
              quota = {
                enable = lib.options.mkOption {
                  default = true;
                  example = false;
                  type = lib.types.bool;
                  description = "Whether to enable the quota system.";
                };
                maxEntity = lib.options.mkOption {
                  default = 1000;
                  example = 1024;
                  type = lib.types.ints.positive;
                  description = "Entity limit for transactions.";
                };
                maxSize = lib.options.mkOption {
                  default = 2048;
                  example = 4096;
                  type = lib.types.ints.positive;
                  description = "Size limit for transactions.";
                };
                maxWatch = lib.options.mkOption {
                  default = 100;
                  example = 256;
                  type = lib.types.ints.positive;
                  description = "Maximum number of watches by the Xenstore Watchdog.";
                };
                transaction = lib.options.mkOption {
                  default = 10;
                  example = 50;
                  type = lib.types.ints.positive;
                  description = "Maximum number of transactions.";
                };
                maxRequests = lib.options.mkOption {
                  default = 1024;
                  example = 1024;
                  type = lib.types.ints.positive;
                  description = "Maximum number of requests per transaction.";
                };
                maxPath = lib.options.mkOption {
                  default = 1024;
                  example = 1024;
                  type = lib.types.ints.positive;
                  description = "Path limit for the quota system.";
                };
                maxOutstanding = lib.options.mkOption {
                  default = 1024;
                  example = 1024;
                  type = lib.types.ints.positive;
                  description = "Maximum outstanding requests, i.e. in-flight requests / domain.";
                };
                maxWatchEvents = lib.options.mkOption {
                  default = 1024;
                  example = 2048;
                  type = lib.types.ints.positive;
                  description = "Maximum number of outstanding watch events per watch.";
                };
              };
              persistent = lib.options.mkOption {
                default = false;
                example = true;
                type = lib.types.bool;
                description = "Whether to activate the filed base backend.";
              };
              xenstored = {
                log = {
                  file = lib.options.mkOption {
                    default = "/var/log/xen/xenstored.log";
                    example = "/dev/null";
                    type = lib.types.path;
                    description = "Path to the Xen Store log file.";
                  };
                  level = lib.options.mkOption {
                    default = if cfg.trace then "debug" else null;
                    defaultText = lib.options.literalExpression "if (config.virtualisation.xen.trace == true) then \"debug\" else null";
                    example = "error";
                    type = lib.types.nullOr (
                      lib.types.enum [
                        "debug"
                        "info"
                        "warn"
                        "error"
                      ]
                    );
                    description = "Logging level for the Xen Store.";
                  };
                  # The hidden options below have no upstream documentation whatsoever.
                  # The nb* options appear to alter the log rotation behaviour, and
                  # the specialOps option appears to affect the Xenbus logging logic.
                  nbFiles = lib.options.mkOption {
                    default = 10;
                    example = 16;
                    type = lib.types.int;
                    visible = false;
                    description = "Set `xenstored-log-nb-files`.";
                  };
                };
                accessLog = {
                  file = lib.options.mkOption {
                    default = "/var/log/xen/xenstored-access.log";
                    example = "/var/log/security/xenstored-access.log";
                    type = lib.types.path;
                    description = "Path to the Xen Store access log file.";
                  };
                  nbLines = lib.options.mkOption {
                    default = 13215;
                    example = 16384;
                    type = lib.types.int;
                    visible = false;
                    description = "Set `access-log-nb-lines`.";
                  };
                  nbChars = lib.options.mkOption {
                    default = 180;
                    example = 256;
                    type = lib.types.int;
                    visible = false;
                    description = "Set `acesss-log-nb-chars`.";
                  };
                  specialOps = lib.options.mkOption {
                    default = false;
                    example = true;
                    type = lib.types.bool;
                    visible = false;
                    description = "Set `access-log-special-ops`.";
                  };
                };
                xenfs = {
                  kva = lib.options.mkOption {
                    default = "/proc/xen/xsd_kva";
                    example = cfg.store.settings.xenstored.xenfs.kva;
                    type = lib.types.path;
                    internal = true;
                    description = ''
                      Path to the Xen Store Daemon KVA location inside the XenFS pseudo-filesystem.
                      While it is possible to alter this value, some drivers may be hardcoded to follow the default paths.
                    '';
                  };
                  port = lib.options.mkOption {
                    default = "/proc/xen/xsd_port";
                    example = cfg.store.settings.xenstored.xenfs.port;
                    type = lib.types.path;
                    internal = true;
                    description = ''
                      Path to the Xen Store Daemon userspace port inside the XenFS pseudo-filesystem.
                      While it is possible to alter this value, some drivers may be hardcoded to follow the default paths.
                    '';
                  };
                };
              };
              ringScanInterval = lib.options.mkOption {
                default = 20;
                example = 30;
                type = lib.types.addCheck (
                  lib.types.int
                  // {
                    name = "nonzeroInt";
                    description = "nonzero signed integer, meaning !=0";
                    descriptionClass = "nonRestrictiveClause";
                  }
                ) (n: n != 0);
                description = ''
                  Perodic scanning for all the rings as a safenet for lazy clients.
                  Define the interval in seconds; set to a negative integer to disable.
                '';
              };
            };
          };
        };
      };

      efi = {
        enable = lib.options.mkOption {
          type = lib.types.bool;
          default = config.boot.loader.systemd-boot.enable; # TODO: Once we generalise the EFI configuration to more bootloaders, use another default that checks for EFI more generally.
          defaultText = lib.options.literalExpression "config.boot.loader.systemd-boot.enable";
          example = true;
          description = "Whether to enable booting dom0 in EFI systems.";
        };

        bootBuilderFlag = lib.options.mkOption {
          internal = true;
          type = lib.types.enum [
            "--release"
            "--report"
            "--debug"
            "--quiet"
          ];
          default = "--release";
          description = ''
            The xenBootBuilder script should be called with exactly one of the following arguments:

            - `--quiet` supresses all messages.

            - `--release` adds a simple "Installing Xen Hypervisor boot entries...done." message to the script.

            - `--report` is the same as `--release`, but it also prints a diff with information on which generations were altered.

            - `--debug` prints information messages for every single step of the script.
          '';
        };

        path = lib.options.mkOption {
          type = lib.types.path;
          default = "${cfg.package.boot}/${cfg.package.efi}";
          defaultText = lib.options.literalExpression "\${config.virtualisation.xen.package.boot}/\${config.virtualisation.xen.package.efi}";
          example = lib.options.literalExpression "\${config.virtualisation.xen.package}/boot/efi/efi/nixos/xen-\${config.virtualisation.xen.package.version}.efi";
          description = ''
            Path to xen.efi. `pkgs.xen` is patched to install the xen.efi file
            on `$boot/boot/xen.efi`, but an unpatched Xen build may install it
            somewhere else, such as `$out/boot/efi/efi/nixos/xen.efi`. Unless
            you're building your own Xen derivation, you should leave this
            option as the default value.
          '';
        };
      };

      dom0Resources = {
        maxVCPUs = lib.options.mkOption {
          default = 0;
          example = 4;
          type = lib.types.ints.unsigned;
          description = ''
            Amount of virtual CPU cores allocated to Domain 0 on boot.
            If set to 0, all cores are assigned to Domain 0, and
            unprivileged domains will compete with Domain 0 for CPU time.
          '';
        };

        memory = lib.options.mkOption {
          default = 0;
          example = 512;
          type = lib.types.ints.unsigned;
          description = ''
            Amount of memory (in MiB) allocated to Domain 0 on boot.
            If set to 0, all memory is assigned to Domain 0, and
            unprivileged domains will compete with Domain 0 for free RAM.
          '';
        };

        maxMemory = lib.options.mkOption {
          default = cfg.dom0Resources.memory;
          defaultText = lib.options.literalExpression "config.virtualisation.xen.dom0Resources.memory";
          example = 1024;
          type = lib.types.ints.unsigned;
          description = ''
            Maximum amount of memory (in MiB) that Domain 0 can
            dynamically allocate to itself. Does nothing if set
            to the same amount as virtualisation.xen.memory, or
            if that option is set to 0.
          '';
        };
      };

      bootParams = lib.options.mkOption {
        default = [ ];
        example = ''
          [
            "iommu=force:true,qinval:true,debug:true"
            "noreboot=true"
            "vga=ask"
          ]
        '';
        type = lib.types.listOf lib.types.str;
        description = ''
          Xen Command Line parameters passed to Domain 0 at boot time.
          Note: these are different from `boot.kernelParams`. See
          the [Xen documentation](https://xenbits.xenproject.org/docs/unstable/misc/xen-command-line.html) for more information.
        '';
      };

      domains = {
        extraConfig = lib.options.mkOption {
          type = lib.types.lines;
          default = "";
          example = ''
            XENDOMAINS_SAVE=/persist/xen/save
            XENDOMAINS_RESTORE=false
            XENDOMAINS_CREATE_USLEEP=10000000
          '';
          description = ''
            Options defined here will override the defaults for xendomains.
            The default options can be seen in the file included from
            /etc/default/xendomains.
          '';
        };
      };
    };
  };

  ###### implementation

  config = lib.modules.mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.isx86_64;
        message = "Xen is currently not supported on ${pkgs.stdenv.hostPlatform.system}.";
      }
      {
        assertion = cfg.efi.enable -> config.boot.loader.systemd-boot.enable;
        message = "Xen currently does not support EFI boot on bootloaders that are not systemd-boot.";
      }
      {
        assertion = !config.boot.loader.systemd-boot.bootCounting.enable;
        message = "Xen currently does not support systemd-boot's boot counting feature.";
      }
      {
        assertion = cfg.dom0Resources.maxMemory >= cfg.dom0Resources.memory;
        message = ''
          You have allocated more memory to dom0 than virtualisation.xen.dom0Resources.maxMemory
          allows for. Please increase the maximum memory limit, or decrease the default memory allocation.
        '';
      }
      {
        assertion = if cfg.debug then if cfg.trace then true else false else true;
        message = "Xen's debugging features are enabled, but logging is disabled. This is most likely not what you want.";
      }
      {
        assertion = cfg.store.settings.quota.maxWatchEvents >= cfg.store.settings.quota.maxOutstanding;
        message = ''
          Upstream Xen recommends that maxWatchEvents be equal to or greater than maxOutstanding,
          in order to mitigate denial of service attacks from malicious frontends.
        '';
      }
    ];

    environment.systemPackages = [
      cfg.package
      cfg.qemu.package
    ];

    virtualisation.xen.bootParams =
      lib.lists.optionals cfg.trace [
        "loglvl=all"
        "guest_loglvl=all"
      ]
      ++
        lib.lists.optional (cfg.dom0Resources.memory != 0)
          "dom0_mem=${toString cfg.dom0Resources.memory}M${
            lib.strings.optionalString (
              cfg.dom0Resources.memory != cfg.dom0Resources.maxMemory
            ) ",max:${toString cfg.dom0Resources.maxMemory}M"
          }"
      ++ lib.lists.optional (
        cfg.dom0Resources.maxVCPUs != 0
      ) "dom0_max_vcpus=${toString cfg.dom0Resources.maxVCPUs}";

    boot = {
      kernelModules = [
        "xen-evtchn"
        "xen-gntdev"
        "xen-gntalloc"
        "xen-blkback"
        "xen-netback"
        "xen-pciback"
        "evtchn"
        "gntdev"
        "netbk"
        "blkbk"
        "xen-scsibk"
        "usbbk"
        "pciback"
        "xen-acpi-processor"
        "blktap2"
        "tun"
        "netxen_nic"
        "xen_wdt"
        "xen-acpi-processor"
        "xen-privcmd"
        "xen-scsiback"
        "xenfs"
      ];

      # The xenfs module is needed in system.activationScripts.xenfs.
      initrd.kernelModules = [ "xenfs" ];

      # The radeonfb kernel module causes the screen to go black as soon
      # as it's loaded, so don't load it.
      blacklistedKernelModules = [ "radeonfb" ];

      # Increase the number of loopback devices from the default (8),
      # which is way too small because every VM virtual disk requires a
      # loopback device.
      extraModprobeConfig = ''
        options loop max_loop=64
      '';

      bootspec.extensions = {
        "org.xenproject.bootspec.v1" = {
          xen = cfg.efi.path;
          xenParams = cfg.bootParams;
        };
      };

      loader.systemd-boot.extraInstallCommands = lib.strings.optionalString cfg.efi.enable ''
        ${xenBootBuilderPath} ${cfg.efi.bootBuilderFlag}
      '';
    };

    system = {
      # Handle legacy BIOS booting.
      extraSystemBuilderCmds = lib.strings.optionalString (!cfg.efi.enable) ''
        ln -s ${cfg.package}/boot/xen.gz $out/xen.gz
        echo "${toString cfg.bootParams}" > $out/xen-params
      '';

      # Mount the /proc/xen pseudo-filesystem if we're not using the systemd stage 1 initrd.
      activationScripts.xenfs = lib.strings.optionalString (!config.boot.initrd.systemd.enable) ''
        if [ -d /proc/xen ]; then
            ${pkgs.util-linux}/bin/mountpoint -q /proc/xen || \
                ${pkgs.util-linux}/bin/mount -t xenfs none /proc/xen
        fi
      '';

      # Domain 0 requires a pvops-enabled kernel.
      requiredKernelConfig = with config.lib.kernelConfig; [
        (isYes "XEN")
        (isYes "X86_IO_APIC")
        (isYes "ACPI")
        (isYes "XEN_DOM0")
        (isYes "PCI_XEN")
        (isYes "XEN_DEV_EVTCHN")
        (isYes "XENFS")
        (isYes "XEN_COMPAT_XENFS")
        (isYes "XEN_SYS_HYPERVISOR")
        (isYes "XEN_GNTDEV")
        (isYes "XEN_BACKEND")
        (isModule "XEN_NETDEV_BACKEND")
        (isModule "XEN_BLKDEV_BACKEND")
        (isModule "XEN_PCIDEV_BACKEND")
        (isYes "XEN_BALLOON")
        (isYes "XEN_SCRUB_PAGES")
      ];
    };

    # Enable the xen:/// connection in virt-manager if enabled.
    programs.dconf.profiles.user.databases = lib.lists.optional config.programs.virt-manager.enable [
      {
        settings."org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "xen:///" ];
          uris = [ "xen:///" ];
        };
      }
    ];

    environment.etc =
      {
        "xen/xl.conf".source = "${cfg.package}/etc/xen/xl.conf"; # TODO: Add options to configure xl.conf declaratively. It's worth considering making a new "xl value" type, as it could be reused to produce xl.cfg (domain definition) files.
        "xen/scripts".source = "${cfg.package}/etc/xen/scripts";
        "default/xencommons".text = ''
          source ${cfg.package}/etc/default/xencommons

          XENSTORED="${cfg.store.path}"
          QEMU_XEN="${cfg.qemu.package}/${cfg.qemu.package.qemu-system-i386}"
          ${lib.strings.optionalString cfg.trace ''
            XENSTORED_TRACE=yes
            XENCONSOLED_TRACE=all
          ''}
        '';
        "default/xendomains".text = ''
          source ${cfg.package}/etc/default/xendomains

          ${cfg.domains.extraConfig}
        '';
      }
      # The OCaml-based Xen Store Daemon requires /etc/xen/oxenstored.conf to start.
      // lib.attrsets.optionalAttrs (cfg.store.type == "ocaml") {
        "xen/oxenstored.conf".text = ''
          pid-file = ${cfg.store.settings.pidFile}
          test-eagain = ${lib.trivial.boolToString cfg.store.settings.testEAGAIN}
          merge-activate = ${toString cfg.store.settings.enableMerge}
          conflict-burst-limit = ${toString cfg.store.settings.conflict.burstLimit}
          conflict-max-history-seconds = ${toString cfg.store.settings.conflict.maxHistorySeconds}
          conflict-rate-limit-is-aggregate = ${toString cfg.store.settings.conflict.rateLimitIsAggregate}
          perms-activate = ${toString cfg.store.settings.perms.enable}
          perms-watch-activate = ${toString cfg.store.settings.perms.enableWatch}
          quota-activate = ${toString cfg.store.settings.quota.enable}
          quota-maxentity = ${toString cfg.store.settings.quota.maxEntity}
          quota-maxsize = ${toString cfg.store.settings.quota.maxSize}
          quota-maxwatch = ${toString cfg.store.settings.quota.maxWatch}
          quota-transaction = ${toString cfg.store.settings.quota.transaction}
          quota-maxrequests = ${toString cfg.store.settings.quota.maxRequests}
          quota-path-max = ${toString cfg.store.settings.quota.maxPath}
          quota-maxoutstanding = ${toString cfg.store.settings.quota.maxOutstanding}
          quota-maxwatchevents = ${toString cfg.store.settings.quota.maxWatchEvents}
          persistent = ${lib.trivial.boolToString cfg.store.settings.persistent}
          xenstored-log-file = ${cfg.store.settings.xenstored.log.file}
          xenstored-log-level = ${
            if isNull cfg.store.settings.xenstored.log.level then
              "null"
            else
              cfg.store.settings.xenstored.log.level
          }
          xenstored-log-nb-files = ${toString cfg.store.settings.xenstored.log.nbFiles}
          access-log-file = ${cfg.store.settings.xenstored.accessLog.file}
          access-log-nb-lines = ${toString cfg.store.settings.xenstored.accessLog.nbLines}
          acesss-log-nb-chars = ${toString cfg.store.settings.xenstored.accessLog.nbChars}
          access-log-special-ops = ${lib.trivial.boolToString cfg.store.settings.xenstored.accessLog.specialOps}
          ring-scan-interval = ${toString cfg.store.settings.ringScanInterval}
          xenstored-kva = ${cfg.store.settings.xenstored.xenfs.kva}
          xenstored-port = ${cfg.store.settings.xenstored.xenfs.port}
        '';
      };

    # Xen provides udev rules.
    services.udev.packages = [ cfg.package ];

    systemd = {
      # Xen provides systemd units.
      packages = [ cfg.package ];

      mounts = [
        {
          description = "Mount /proc/xen files";
          what = "xenfs";
          where = "/proc/xen";
          type = "xenfs";
          unitConfig = {
            ConditionPathExists = "/proc/xen";
            RefuseManualStop = "true";
          };
        }
      ];

      services = {
        xenstored = {
          wantedBy = [ "multi-user.target" ];
          preStart = ''
            export XENSTORED_ROOTDIR="/var/lib/xenstored"
            rm -f "$XENSTORED_ROOTDIR"/tdb* &>/dev/null
            mkdir -p /var/{run,log,lib}/xen
          '';
        };

        xen-init-dom0 = {
          restartIfChanged = false;
          wantedBy = [ "multi-user.target" ];
        };

        xen-qemu-dom0-disk-backend = {
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            PIDFile = cfg.qemu.pidFile;
            ExecStart = ''
              ${cfg.qemu.package}/${cfg.qemu.package.qemu-system-i386} \
              -xen-domid 0 -xen-attach -name dom0 -nographic -M xenpv \
              -daemonize -monitor /dev/null -serial /dev/null -parallel \
              /dev/null -nodefaults -no-user-config -pidfile \
              ${cfg.qemu.pidFile}
            '';
          };
        };

        xendriverdomain.wantedBy = [ "multi-user.target" ];

        xenconsoled.wantedBy = [ "multi-user.target" ];

        xen-watchdog = {
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            RestartSec = "1";
            Restart = "on-failure";
          };
        };

        xendomains = {
          restartIfChanged = false;
          path = [
            cfg.package
            cfg.qemu.package
          ];
          preStart = "mkdir -p /var/lock/subsys -m 755";
          wantedBy = [ "multi-user.target" ];
        };
      };
    };
  };
  meta.maintainers = [ lib.maintainers.sigmasquadron ];
}
