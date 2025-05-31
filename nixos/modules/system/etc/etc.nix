# Management of static files in /etc.
{
  config,
  lib,
  pkgs,
  ...
}:
let

  etc' = lib.filter (f: f.enable) (lib.attrValues config.environment.etc);

  etc =
    pkgs.runCommandLocal "etc"
      {
        # This is needed for the systemd module
        passthru.targets = map (x: x.target) etc';
      } # sh
      ''
        set -euo pipefail

        makeEtcEntry() {
          src="$1"
          target="$2"
          mode="$3"
          user="$4"
          group="$5"

          if [[ "$src" = *'*'* ]]; then
            # If the source name contains '*', perform globbing.
            mkdir -p "$out/etc/$target"
            for fn in $src; do
                ln -s "$fn" "$out/etc/$target/"
            done
          else

            mkdir -p "$out/etc/$(dirname "$target")"
            if ! [ -e "$out/etc/$target" ]; then
              ln -s "$src" "$out/etc/$target"
            else
              echo "duplicate entry $target -> $src"
              if [ "$(readlink "$out/etc/$target")" != "$src" ]; then
                echo "mismatched duplicate entry $(readlink "$out/etc/$target") <-> $src"
                ret=1
              fi
            fi

            if [ "$mode" != symlink ]; then
              echo "$mode" > "$out/etc/$target.mode"
              echo "$user" > "$out/etc/$target.uid"
              echo "$group" > "$out/etc/$target.gid"
            fi
          fi
        }

        mkdir -p "$out/etc"
        ${lib.concatMapStringsSep "\n" (
          etcEntry:
          lib.escapeShellArgs [
            "makeEtcEntry"
            # Force local source paths to be added to the store
            "${etcEntry.source}"
            etcEntry.target
            etcEntry.mode
            etcEntry.user
            etcEntry.group
          ]
        ) etc'}
      '';

  etcHardlinks = lib.filter (f: f.mode != "symlink" && f.mode != "direct-symlink") etc';

in

{

  imports = [ ../build.nix ];

  ###### interface

  options = {

    system.etc.overlay = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Mount `/etc` as an overlayfs instead of generating it via a perl script.

          Note: This is currently experimental. Only enable this option if you're
          confident that you can recover your system if it breaks.
        '';
      };

      mutable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to mount `/etc` mutably (i.e. read-write) or immutably (i.e. read-only).

          If this is false, only the immutable lowerdir is mounted. If it is
          true, a writable upperdir is mounted on top.
        '';
      };
    };

    environment.etc = lib.mkOption {
      default = { };
      example = lib.literalExpression ''
        { example-configuration-file =
            { source = "/nix/store/.../etc/dir/file.conf.example";
              mode = "0440";
            };
          "default/useradd".text = "GROUP=100 ...";
        }
      '';
      description = ''
        Set of files that have to be linked in {file}`/etc`.
      '';

      type =
        with lib.types;
        attrsOf (
          submodule (
            {
              name,
              config,
              options,
              ...
            }:
            {
              options = {

                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = ''
                    Whether this /etc file should be generated.  This
                    option allows specific /etc files to be disabled.
                  '';
                };

                target = lib.mkOption {
                  type = lib.types.str;
                  description = ''
                    Name of symlink (relative to
                    {file}`/etc`).  Defaults to the attribute
                    name.
                  '';
                };

                text = lib.mkOption {
                  default = null;
                  type = lib.types.nullOr lib.types.lines;
                  description = "Text of the file.";
                };

                source = lib.mkOption {
                  type = lib.types.path;
                  description = "Path of the source file.";
                };

                mode = lib.mkOption {
                  type = lib.types.str;
                  default = "symlink";
                  example = "0600";
                  description = ''
                    If set to something else than `symlink`,
                    the file is copied instead of symlinked, with the given
                    file mode.
                  '';
                };

                uid = lib.mkOption {
                  default = 0;
                  type = lib.types.int;
                  description = ''
                    UID of created file. Only takes effect when the file is
                    copied (that is, the mode is not 'symlink').
                  '';
                };

                gid = lib.mkOption {
                  default = 0;
                  type = lib.types.int;
                  description = ''
                    GID of created file. Only takes effect when the file is
                    copied (that is, the mode is not 'symlink').
                  '';
                };

                user = lib.mkOption {
                  default = "+${toString config.uid}";
                  type = lib.types.str;
                  description = ''
                    User name of file owner.

                    Only takes effect when the file is copied (that is, the
                    mode is not `symlink`).

                    When `services.userborn.enable`, this option has no effect.
                    You have to assign a `uid` instead. Otherwise this option
                    takes precedence over `uid`.
                  '';
                };

                group = lib.mkOption {
                  default = "+${toString config.gid}";
                  type = lib.types.str;
                  description = ''
                    Group name of file owner.

                    Only takes effect when the file is copied (that is, the
                    mode is not `symlink`).

                    When `services.userborn.enable`, this option has no effect.
                    You have to assign a `gid` instead. Otherwise this option
                    takes precedence over `gid`.
                  '';
                };

              };

              config = {
                target = lib.mkDefault name;
                source = lib.mkIf (config.text != null) (
                  let
                    name' = "etc-" + lib.replaceStrings [ "/" ] [ "-" ] name;
                  in
                  lib.mkDerivedConfig options.text (pkgs.writeText name')
                );
              };

            }
          )
        );

    };

  };

  ###### implementation

  config = {

    system.build.etc = etc;
    system.build.etcActivationCommands =
      let
        etcOverlayOptions = lib.concatStringsSep "," (
          [
            "relatime"
            "redirect_dir=on"
            "metacopy=on"
          ]
          ++ lib.optionals config.system.etc.overlay.mutable [
            "upperdir=/.rw-etc/upper"
            "workdir=/.rw-etc/work"
          ]
        );
      in
      if config.system.etc.overlay.enable then
        #bash
        ''
          # This script atomically remounts /etc when switching configuration.
          # On a (re-)boot this should not run because /etc is mounted via a
          # systemd mount unit instead.
          # The activation script can also be called in cases where we didn't have
          # an initrd though, like for instance when using  nixos-enter,
          # so we cannot assume that /etc has already been mounted.
          #
          # To a large extent this mimics what composefs does. Because
          # it's relatively simple, however, we avoid the composefs dependency.
          # Since this script is not idempotent, it should not run when etc hasn't
          # changed.
          if [[ ! $IN_NIXOS_SYSTEMD_STAGE1 ]] && [[ "${config.system.build.etc}/etc" != "$(readlink -f /run/current-system/etc)" ]]; then
            echo "remounting /etc..."

            ${lib.optionalString config.system.etc.overlay.mutable ''
              # These directories are usually created in initrd,
              # but we need to create them here when we're called directly,
              # for instance by nixos-enter
              mkdir --parents /.rw-etc/upper /.rw-etc/work
              chmod 0755 /.rw-etc /.rw-etc/upper /.rw-etc/work
            ''}

            tmpMetadataMount=$(TMPDIR="/run" mktemp --directory -t nixos-etc-metadata.XXXXXXXXXX)
            mount --type erofs --options ro,nodev,nosuid ${config.system.build.etcMetadataImage} $tmpMetadataMount

            # There was no previous /etc mounted. This happens when we're called
            # directly without an initrd, like with nixos-enter.
            if ! mountpoint -q /etc; then
              mount --type overlay \
                --options nodev,nosuid,lowerdir=$tmpMetadataMount::${config.system.build.etcBasedir},${etcOverlayOptions} \
                overlay /etc
            else
              # Mount the new /etc overlay to a temporary private mount.
              # This needs the indirection via a private bind mount because you
              # cannot move shared mounts.
              tmpEtcMount=$(TMPDIR="/run" mktemp --directory -t nixos-etc.XXXXXXXXXX)
              mount --bind --make-private $tmpEtcMount $tmpEtcMount
              mount --type overlay \
                --options nodev,nosuid,lowerdir=$tmpMetadataMount::${config.system.build.etcBasedir},${etcOverlayOptions} \
                overlay $tmpEtcMount

              # Before moving the new /etc overlay under the old /etc, we have to
              # move mounts on top of /etc to the new /etc mountpoint.
              findmnt /etc --submounts --list --noheading --kernel --output TARGET | while read -r mountPoint; do
                if [[ "$mountPoint" = "/etc" ]]; then
                  continue
                fi

                tmpMountPoint="$tmpEtcMount/''${mountPoint:5}"
                  ${
                    if config.system.etc.overlay.mutable then
                      ''
                        if [[ -f "$mountPoint" ]]; then
                          touch "$tmpMountPoint"
                        elif [[ -d "$mountPoint" ]]; then
                          mkdir -p "$tmpMountPoint"
                        fi
                      ''
                    else
                      ''
                        if [[ ! -e "$tmpMountPoint" ]]; then
                          echo "Skipping undeclared mountpoint in environment.etc: $mountPoint"
                          continue
                        fi
                      ''
                  }
                mount --bind "$mountPoint" "$tmpMountPoint"
              done

              # Move the new temporary /etc mount underneath the current /etc mount.
              #
              # This should eventually use util-linux to perform this move beneath,
              # however, this functionality is not yet in util-linux. See this
              # tracking issue: https://github.com/util-linux/util-linux/issues/2604
              ${pkgs.move-mount-beneath}/bin/move-mount --move --beneath $tmpEtcMount /etc

              # Unmount the top /etc mount to atomically reveal the new mount.
              umount --lazy --recursive /etc

              # Unmount the temporary mount
              umount --lazy "$tmpEtcMount"
              rmdir "$tmpEtcMount"
            fi

            # Unmount old metadata mounts
            # For some reason, `findmnt /tmp --submounts` does not show the nested
            # mounts. So we'll just find all mounts of type erofs and filter on the
            # name of the mountpoint.
            findmnt --type erofs --list --kernel --output TARGET | while read -r mountPoint; do
              if [[ ("$mountPoint" =~ ^/run/nixos-etc-metadata\..{10}$ || "$mountPoint" =~ ^/run/nixos-etc-metadata$ ) &&
                    "$mountPoint" != "$tmpMetadataMount" ]]; then
                umount --lazy "$mountPoint"
                rmdir "$mountPoint"
              fi
            done
          fi
        ''
      else
        ''
          # Set up the statically computed bits of /etc.
          echo "setting up /etc..."
          ${pkgs.perl.withPackages (p: [ p.FileSlurp ])}/bin/perl ${./setup-etc.pl} ${etc}/etc
        '';

    system.build.etcBasedir = pkgs.runCommandLocal "etc-lowerdir" { } ''
      set -euo pipefail

      makeEtcEntry() {
        src="$1"
        target="$2"

        mkdir -p "$out/$(dirname "$target")"
        cp "$src" "$out/$target"
      }

      mkdir -p "$out"
      ${lib.concatMapStringsSep "\n" (
        etcEntry:
        lib.escapeShellArgs [
          "makeEtcEntry"
          # Force local source paths to be added to the store
          "${etcEntry.source}"
          etcEntry.target
        ]
      ) etcHardlinks}
    '';

    system.build.etcMetadataImage =
      let
        etcJson = pkgs.writeText "etc-json" (builtins.toJSON etc');
        etcDump = pkgs.runCommandLocal "etc-dump" { } ''
          ${lib.getExe pkgs.buildPackages.python3} ${./build-composefs-dump.py} ${etcJson} > $out
        '';
      in
      pkgs.runCommandLocal "etc-metadata.erofs"
        {
          nativeBuildInputs = with pkgs.buildPackages; [
            composefs
            erofs-utils
          ];
        }
        ''
          mkcomposefs --from-file ${etcDump} $out
          fsck.erofs $out
        '';

  };

}
