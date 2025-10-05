{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) attrNames hasAttr isAttrs;
  inherit (lib) getLib;
  inherit (config.environment) etc;
  # Utility to generate an AppArmor rule
  # only when the given path exists in config.environment.etc
  etcRule =
    arg:
    let
      go =
        {
          path ? null,
          mode ? "r",
          trail ? "",
        }:
        lib.optionalString (hasAttr path etc) "${mode} ${config.environment.etc.${path}.source}${trail},";
    in
    if isAttrs arg then go arg else go { path = arg; };
in
{
  # FIXME: most of the etcRule calls below have been
  # written systematically by converting from apparmor-profiles's profiles
  # without testing nor deep understanding of their uses,
  # and thus may need more rules or can have less rules;
  # this remains to be determined case by case,
  # some may even be completely useless.
  config.security.apparmor.includes = {
    # This one is included by <tunables/global>
    # which is usually included before any profile.
    "abstractions/tunables/alias" = ''
      alias /bin -> /run/current-system/sw/bin,
      alias /lib/modules -> /run/current-system/kernel/lib/modules,
      alias /sbin -> /run/current-system/sw/sbin,
      alias /usr -> /run/current-system/sw,
    '';
    "abstractions/audio" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/audio"
    ''
    + lib.concatMapStringsSep "\n" etcRule [
      "asound.conf"
      "esound/esd.conf"
      "libao.conf"
      {
        path = "pulse";
        trail = "/";
      }
      {
        path = "pulse";
        trail = "/**";
      }
      {
        path = "sound";
        trail = "/";
      }
      {
        path = "sound";
        trail = "/**";
      }
      {
        path = "alsa/conf.d";
        trail = "/";
      }
      {
        path = "alsa/conf.d";
        trail = "/*";
      }
      "openal/alsoft.conf"
      "wildmidi/wildmidi.conf"
    ];
    "abstractions/authentication" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/authentication"
      # Defined in security.pam
      include <abstractions/pam>
    ''
    + lib.concatMapStringsSep "\n" etcRule [
      "nologin"
      "securetty"
      {
        path = "security";
        trail = "/*";
      }
      "shadow"
      "gshadow"
      "pwdb.conf"
      "default/passwd"
      "login.defs"
    ];
    "abstractions/base" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/base"
      r ${pkgs.stdenv.cc.libc}/share/locale/**,
      r ${pkgs.stdenv.cc.libc}/share/locale.alias,
      r ${config.i18n.glibcLocales}/lib/locale/locale-archive,
      ${etcRule "localtime"}
      r ${pkgs.tzdata}/share/zoneinfo/**,
      r ${pkgs.stdenv.cc.libc}/share/i18n/**,
    '';
    "abstractions/bash" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/bash"

      # bash inspects filesystems at startup
      # and /etc/mtab is linked to /proc/mounts
      r @{PROC}/mounts,

      # system-wide bash configuration
    ''
    + lib.concatMapStringsSep "\n" etcRule [
      "profile.dos"
      "profile"
      "profile.d"
      {
        path = "profile.d";
        trail = "/*";
      }
      "bashrc"
      "bash.bashrc"
      "bash.bashrc.local"
      "bash_completion"
      "bash_completion.d"
      {
        path = "bash_completion.d";
        trail = "/*";
      }
      # bash relies on system-wide readline configuration
      "inputrc"
      # run out of /etc/bash.bashrc
      "DIR_COLORS"
    ];
    "abstractions/consoles" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/consoles"
    '';
    "abstractions/cups-client" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/cups-client"
      ${etcRule "cups/cups-client.conf"}
    '';
    "abstractions/dbus-session-strict" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/dbus-session-strict"
      ${etcRule "machine-id"}
    '';
    "abstractions/dconf" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/dconf"
      ${etcRule {
        path = "dconf";
        trail = "/**";
      }}
    '';
    "abstractions/dri-common" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/dri-common"
      ${etcRule "drirc"}
    '';
    # The config.fonts.fontconfig NixOS module adds many files to /etc/fonts/
    # by symlinking them but without exporting them outside of its NixOS module,
    # those are therefore added there to this "abstractions/fonts".
    "abstractions/fonts" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/fonts"
      ${etcRule {
        path = "fonts";
        trail = "/**";
      }}
    '';
    "abstractions/gnome" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/gnome"
      include <abstractions/fonts>
    ''
    + lib.concatMapStringsSep "\n" etcRule [
      {
        path = "gnome";
        trail = "/gtkrc*";
      }
      {
        path = "gtk";
        trail = "/*";
      }
      {
        path = "gtk-2.0";
        trail = "/*";
      }
      {
        path = "gtk-3.0";
        trail = "/*";
      }
      "orbitrc"
      {
        path = "pango";
        trail = "/*";
      }
      {
        path = "/etc/gnome-vfs-2.0";
        trail = "/modules/";
      }
      {
        path = "/etc/gnome-vfs-2.0";
        trail = "/modules/*";
      }
      "papersize"
      {
        path = "cups";
        trail = "/lpoptions";
      }
      {
        path = "gnome";
        trail = "/defaults.list";
      }
      {
        path = "xdg";
        trail = "/{,*-}mimeapps.list";
      }
      "xdg/mimeapps.list"
    ];
    "abstractions/kde" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/kde"
    ''
    + lib.concatMapStringsSep "\n" etcRule [
      {
        path = "qt3";
        trail = "/kstylerc";
      }
      {
        path = "qt3";
        trail = "/qt_plugins_3.3rc";
      }
      {
        path = "qt3";
        trail = "/qtrc";
      }
      "kderc"
      {
        path = "kde3";
        trail = "/*";
      }
      "kde4rc"
      {
        path = "xdg";
        trail = "/kdeglobals";
      }
      {
        path = "xdg";
        trail = "/Trolltech.conf";
      }
    ];
    "abstractions/kerberosclient" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/kerberosclient"
    ''
    + lib.concatMapStringsSep "\n" etcRule [
      {
        path = "krb5.keytab";
        mode = "rk";
      }
      "krb5.conf"
      "krb5.conf.d"
      {
        path = "krb5.conf.d";
        trail = "/*";
      }

      # config files found via strings on libs
      "krb.conf"
      "krb.realms"
      "srvtab"
    ];
    "abstractions/ldapclient" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/ldapclient"
    ''
    + lib.concatMapStringsSep "\n" etcRule [
      "ldap.conf"
      "ldap.secret"
      {
        path = "openldap";
        trail = "/*";
      }
      {
        path = "openldap";
        trail = "/cacerts/*";
      }
      {
        path = "sasl2";
        trail = "/*";
      }
    ];
    "abstractions/likewise" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/likewise"
    '';
    "abstractions/mdns" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/mdns"
      ${etcRule "nss_mdns.conf"}
    '';
    "abstractions/nameservice" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/nameservice"

      # Many programs wish to perform nameservice-like operations, such as
      # looking up users by name or id, groups by name or id, hosts by name
      # or IP, etc. These operations may be performed through files, dns,
      # NIS, NIS+, LDAP, hesiod, wins, etc. Allow them all here.
      mr ${getLib pkgs.nss}/lib/libnss_*.so*,
      mr ${getLib pkgs.nss}/lib64/libnss_*.so*,
    ''
    + lib.concatMapStringsSep "\n" etcRule [
      "group"
      "host.conf"
      "hosts"
      "nsswitch.conf"
      "gai.conf"
      "passwd"
      "protocols"

      # libtirpc (used for NIS/YP login) needs this
      "netconfig"

      "resolv.conf"

      {
        path = "samba";
        trail = "/lmhosts";
      }
      "services"

      "default/nss"

      # libnl-3-200 via libnss-gw-name
      {
        path = "libnl";
        trail = "/classid";
      }
      {
        path = "libnl-3";
        trail = "/classid";
      }
    ];
    "abstractions/nis" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/nis"
    '';
    "abstractions/nss-systemd" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/nss-systemd"
    '';
    "abstractions/nvidia" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/nvidia"
      ${etcRule "vdpau_wrapper.cfg"}
    '';
    "abstractions/opencl-common" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/opencl-common"
      ${etcRule {
        path = "OpenCL";
        trail = "/**";
      }}
    '';
    "abstractions/opencl-mesa" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/opencl-mesa"
      ${etcRule "default/drirc"}
    '';
    "abstractions/openssl" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/openssl"
      ${etcRule {
        path = "ssl";
        trail = "/openssl.cnf";
      }}
    '';
    "abstractions/p11-kit" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/p11-kit"
    ''
    + lib.concatMapStringsSep "\n" etcRule [
      {
        path = "pkcs11";
        trail = "/";
      }
      {
        path = "pkcs11";
        trail = "/pkcs11.conf";
      }
      {
        path = "pkcs11";
        trail = "/modules/";
      }
      {
        path = "pkcs11";
        trail = "/modules/*";
      }
    ];
    "abstractions/perl" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/perl"
      ${etcRule {
        path = "perl";
        trail = "/**";
      }}
    '';
    "abstractions/php" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/php"
    ''
    + lib.concatMapStringsSep "\n" etcRule [
      {
        path = "php";
        trail = "/**/";
      }
      {
        path = "php5";
        trail = "/**/";
      }
      {
        path = "php7";
        trail = "/**/";
      }
      {
        path = "php";
        trail = "/**.ini";
      }
      {
        path = "php5";
        trail = "/**.ini";
      }
      {
        path = "php7";
        trail = "/**.ini";
      }
    ];
    "abstractions/postfix-common" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/postfix-common"
    ''
    + lib.concatMapStringsSep "\n" etcRule [
      "mailname"
      {
        path = "postfix";
        trail = "/*.cf";
      }
      "postfix/main.cf"
      "postfix/master.cf"
    ];
    "abstractions/python" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/python"
    '';
    "abstractions/qt5" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/qt5"
    ''
    + lib.concatMapStringsSep "\n" etcRule [
      {
        path = "xdg";
        trail = "/QtProject/qtlogging.ini";
      }
      {
        path = "xdg/QtProject";
        trail = "/qtlogging.ini";
      }
      "xdg/QtProject/qtlogging.ini"
    ];
    "abstractions/samba" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/samba"
      ${etcRule {
        path = "samba";
        trail = "/*";
      }}
    '';
    "abstractions/ssl_certs" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/ssl_certs"

      # For the NixOS module: security.acme
      r /var/lib/acme/*/cert.pem,
      r /var/lib/acme/*/chain.pem,
      r /var/lib/acme/*/fullchain.pem,

      r /etc/pki/tls/certs/,

    ''
    + lib.concatMapStringsSep "\n" etcRule [
      "ssl/certs/ca-certificates.crt"
      "ssl/certs/ca-bundle.crt"
      "pki/tls/certs/ca-bundle.crt"

      {
        path = "ssl/trust";
        trail = "/";
      }
      {
        path = "ssl/trust";
        trail = "/*";
      }
      {
        path = "ssl/trust/anchors";
        trail = "/";
      }
      {
        path = "ssl/trust/anchors";
        trail = "/**";
      }
      {
        path = "pki/trust";
        trail = "/";
      }
      {
        path = "pki/trust";
        trail = "/*";
      }
      {
        path = "pki/trust/anchors";
        trail = "/";
      }
      {
        path = "pki/trust/anchors";
        trail = "/**";
      }
    ];
    "abstractions/ssl_keys" = ''
      # security.acme NixOS module
      r /var/lib/acme/*/full.pem,
      r /var/lib/acme/*/key.pem,
    '';
    "abstractions/vulkan" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/vulkan"
      ${etcRule {
        path = "vulkan/icd.d";
        trail = "/";
      }}
      ${etcRule {
        path = "vulkan/icd.d";
        trail = "/*.json";
      }}
    '';
    "abstractions/winbind" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/winbind"
      ${etcRule {
        path = "samba";
        trail = "/smb.conf";
      }}
      ${etcRule {
        path = "samba";
        trail = "/dhcp.conf";
      }}
    '';
    "abstractions/X" = ''
      include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/X"
      ${etcRule {
        path = "X11/cursors";
        trail = "/";
      }}
      ${etcRule {
        path = "X11/cursors";
        trail = "/**";
      }}
    '';
  };
}
