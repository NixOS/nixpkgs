{ config, pkgs, ... }:

with pkgs.lib;

let

  # `pam_console' maintains the set of locally logged in users in
  # /var/run/console.  This is obsolete, but D-Bus still uses it for
  # its `at_console' feature.  So maintain it using a ConsoleKit
  # session script.  Borrowed from
  # http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/sys-auth/consolekit/files/pam-foreground-compat.ck
  updateVarRunConsole = pkgs.writeTextFile {
    name = "var-run-console.ck";
    destination = "/etc/ConsoleKit/run-session.d/var-run-console.ck";
    executable = true;
    
    text =
      ''
        #! ${pkgs.stdenv.shell} -e
        PATH=${pkgs.coreutils}/bin:${pkgs.gnused}/bin:${pkgs.glibc}/bin
        TAGDIR=/var/run/console

        exec >> /tmp/xyzzy 2>&1

        [ -n "$CK_SESSION_USER_UID" ] || exit 1

        TAGFILE="$TAGDIR/`getent passwd $CK_SESSION_USER_UID | cut -f 1 -d:`"

        if [ "$1" = "session_added" ]; then
            mkdir -p "$TAGDIR"
            echo "$CK_SESSION_ID" >> "$TAGFILE"
        fi

        if [ "$1" = "session_removed" ] && [ -e "$TAGFILE" ]; then
            sed -i "\%^$CK_SESSION_ID\$%d" "$TAGFILE"
            [ -s "$TAGFILE" ] || rm -f "$TAGFILE"
        fi
      '';
  };

in

{

  config = {

    environment.systemPackages = [ pkgs.consolekit ];

    services.dbus.packages = [ pkgs.consolekit ];

    environment.etc = singleton
      { source = (pkgs.buildEnv {
          name = "consolekit-config";
          pathsToLink = [ "/etc/ConsoleKit" ];
          paths = [ pkgs.consolekit pkgs.udev updateVarRunConsole ];
        }) + "/etc/ConsoleKit";
        target = "ConsoleKit";
      };

  };

}
