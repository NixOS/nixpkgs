{ config, lib, pkgs, ... }:
let

  inherit (config.security) wrapperDir;

in
{

  ###### interface

  options = {
    security.wrappers = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      example = lib.literalExample
        ''
          { sendmail.source = "/nix/store/.../bin/sendmail";
            ping = {
              source  = "${pkgs.iputils.out}/bin/ping";
              owner   = "nobody";
              group   = "nogroup";
              capabilities = "cap_net_raw+ep";
            };
          }
        '';
      description = ''
        This option allows the ownership and permissions on the setuid
        wrappers for specific programs to be overridden from the
        default (setuid root, but not setgid root).

        <note>
          <para>The sub-attribute <literal>source</literal> is mandatory,
          it must be the absolute path to the program to be wrapped.
          </para>

          <para>The sub-attribute <literal>program</literal> is optional and
          can give the wrapper program a new name. The default name is the same
          as the attribute name itself.</para>

          <para>Additionally, this option can set capabilities on a
          wrapper program that propagates those capabilities down to the
          wrapped, real program.</para>

          <para>NOTE: cap_setpcap, which is required for the wrapper
          program to be able to raise caps into the Ambient set is NOT
          raised to the Ambient set so that the real program cannot
          modify its own capabilities!! This may be too restrictive for
          cases in which the real program needs cap_setpcap but it at
          least leans on the side security paranoid vs. too
          relaxed.</para>
        </note>
      '';
    };

    security.wrapperDir = lib.mkOption {
      type        = lib.types.path;
      default     = "/run/wrappers/bin";
      internal    = true;
      description = ''
        This option defines the path to the wrapper programs. It
        should not be overriden.
      '';
    };
  };

  ###### implementation
  config = {

    security.wrappers = {
      fusermount.source = "${pkgs.fuse}/bin/fusermount";
      fusermount3.source = "${pkgs.fuse3}/bin/fusermount3";
    };

    # Make sure our wrapperDir exports to the PATH env variable when
    # initializing the shell
    environment.extraInit = ''
      # Wrappers override other bin directories.
      export PATH="${wrapperDir}:$PATH"
    '';

    ###### setcap activation script
    system.activationScripts.wrappers =
      lib.stringAfter [ "specialfs" "users" ]
        ''
          ${pkgs.security-wrappers {
              inherit (config.security) wrapperDir wrappers;
            }}/bin/setup
        '';
  };
}
