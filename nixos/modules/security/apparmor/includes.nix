{ config, lib, pkgs, ... }:
let
  inherit (builtins) attrNames hasAttr isAttrs;
  inherit (lib) getLib;
  inherit (config.environment) etc;
  etcRule = arg:
    let go = {path ? null, mode ? "r", trail ? ""}:
      lib.optionalString (hasAttr path etc)
        "${mode} ${config.environment.etc.${path}.source}${trail},";
    in if isAttrs arg
    then go arg
    else go {path=arg;};
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
  # which is usualy included before any profile.
  "abstractions/tunables/alias" = ''
    alias /bin -> /run/current-system/sw/bin,
    alias /lib/modules -> /run/current-system/kernel/lib/modules,
    alias /sbin -> /run/current-system/sw/sbin,
    alias /usr -> /run/current-system/sw,
  '';
  "abstractions/audio" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/audio"
    ${etcRule "asound.conf"}
    ${etcRule "esound/esd.conf"}
    ${etcRule "libao.conf"}
    ${etcRule {path="pulse"; trail="/";}}
    ${etcRule {path="pulse"; trail="/**";}}
    ${etcRule {path="sound"; trail="/";}}
    ${etcRule {path="sound"; trail="/**";}}
    ${etcRule {path="alsa/conf.d"; trail="/";}}
    ${etcRule {path="alsa/conf.d"; trail="/*";}}
    ${etcRule "openal/alsoft.conf"}
    ${etcRule "wildmidi/wildmidi.conf"}
  '';
  "abstractions/authentication" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/authentication"
    # Defined in security.pam
    include <abstractions/pam>
    ${etcRule "nologin"}
    ${etcRule "securetty"}
    ${etcRule {path="security"; trail="/*";}}
    ${etcRule "shadow"}
    ${etcRule "gshadow"}
    ${etcRule "pwdb.conf"}
    ${etcRule "default/passwd"}
    ${etcRule "login.defs"}
  '';
  "abstractions/base" = ''
     include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/base"
     r ${pkgs.stdenv.cc.libc}/share/locale/**,
     r ${pkgs.stdenv.cc.libc}/share/locale.alias,
     ${lib.optionalString (pkgs.glibcLocales != null) "r ${pkgs.glibcLocales}/lib/locale/locale-archive,"}
     ${etcRule "localtime"}
     r ${pkgs.tzdata}/share/zoneinfo/**,
     r ${pkgs.stdenv.cc.libc}/share/i18n/**,
  '';
  "abstractions/bash" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/bash"
    # system-wide bash configuration
    ${etcRule "profile.dos"}
    ${etcRule "profile"}
    ${etcRule "profile.d"}
    ${etcRule {path="profile.d"; trail="/*";}}
    ${etcRule "bashrc"}
    ${etcRule "bash.bashrc"}
    ${etcRule "bash.bashrc.local"}
    ${etcRule "bash_completion"}
    ${etcRule "bash_completion.d"}
    ${etcRule {path="bash_completion.d"; trail="/*";}}
    # bash relies on system-wide readline configuration
    ${etcRule "inputrc"}
    # bash inspects filesystems at startup
    # and /etc/mtab is linked to /proc/mounts
    @{PROC}/mounts

    # run out of /etc/bash.bashrc
    ${etcRule "DIR_COLORS"}
  '';
  "abstractions/cups-client" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/cpus-client"
    ${etcRule "cups/cups-client.conf"}
  '';
  "abstractions/consoles" = ''
     include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/consoles"
  '';
  "abstractions/dbus-session-strict" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/dbus-session-strict"
    ${etcRule "machine-id"}
  '';
  "abstractions/dconf" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/dconf"
    ${etcRule {path="dconf"; trail="/**";}}
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
    ${etcRule {path="fonts"; trail="/**";}}
  '';
  "abstractions/gnome" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/gnome"
    ${etcRule {path="gnome"; trail="/gtkrc*";}}
    ${etcRule {path="gtk"; trail="/*";}}
    ${etcRule {path="gtk-2.0"; trail="/*";}}
    ${etcRule {path="gtk-3.0"; trail="/*";}}
    ${etcRule "orbitrc"}
    include <abstractions/fonts>
    ${etcRule {path="pango"; trail="/*";}}
    ${etcRule {path="/etc/gnome-vfs-2.0"; trail="/modules/";}}
    ${etcRule {path="/etc/gnome-vfs-2.0"; trail="/modules/*";}}
    ${etcRule "papersize"}
    ${etcRule {path="cups"; trail="/lpoptions";}}
    ${etcRule {path="gnome"; trail="/defaults.list";}}
    ${etcRule {path="xdg"; trail="/{,*-}mimeapps.list";}}
    ${etcRule "xdg/mimeapps.list"}
  '';
  "abstractions/kde" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/kde"
    ${etcRule {path="qt3"; trail="/kstylerc";}}
    ${etcRule {path="qt3"; trail="/qt_plugins_3.3rc";}}
    ${etcRule {path="qt3"; trail="/qtrc";}}
    ${etcRule "kderc"}
    ${etcRule {path="kde3"; trail="/*";}}
    ${etcRule "kde4rc"}
    ${etcRule {path="xdg"; trail="/kdeglobals";}}
    ${etcRule {path="xdg"; trail="/Trolltech.conf";}}
  '';
  "abstractions/kerberosclient" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/kerberosclient"
    ${etcRule {path="krb5.keytab"; mode="rk";}}
    ${etcRule "krb5.conf"}
    ${etcRule "krb5.conf.d"}
    ${etcRule {path="krb5.conf.d"; trail="/*";}}

    # config files found via strings on libs
    ${etcRule "krb.conf"}
    ${etcRule "krb.realms"}
    ${etcRule "srvtab"}
  '';
  "abstractions/ldapclient" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/ldapclient"
    ${etcRule "ldap.conf"}
    ${etcRule "ldap.secret"}
    ${etcRule {path="openldap"; trail="/*";}}
    ${etcRule {path="openldap"; trail="/cacerts/*";}}
    ${etcRule {path="sasl2"; trail="/*";}}
  '';
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
    ${etcRule "group"}
    ${etcRule "host.conf"}
    ${etcRule "hosts"}
    ${etcRule "nsswitch.conf"}
    ${etcRule "gai.conf"}
    ${etcRule "passwd"}
    ${etcRule "protocols"}

    # libtirpc (used for NIS/YP login) needs this
    ${etcRule "netconfig"}

    ${etcRule "resolv.conf"}

    ${etcRule {path="samba"; trail="/lmhosts";}}
    ${etcRule "services"}

    ${etcRule "default/nss"}

    # libnl-3-200 via libnss-gw-name
    ${etcRule {path="libnl"; trail="/classid";}}
    ${etcRule {path="libnl-3"; trail="/classid";}}

    mr ${getLib pkgs.nss}/lib/libnss_*.so*,
    mr ${getLib pkgs.nss}/lib64/libnss_*.so*,
  '';
  "abstractions/nis" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/nis"
  '';
  "abstractions/nvidia" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/nvidia"
    ${etcRule "vdpau_wrapper.cfg"}
  '';
  "abstractions/opencl-common" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/opencl-common"
    ${etcRule {path="OpenCL"; trail="/**";}}
  '';
  "abstractions/opencl-mesa" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/opencl-mesa"
    ${etcRule "default/drirc"}
  '';
  "abstractions/openssl" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/openssl"
    ${etcRule {path="ssl"; trail="/openssl.cnf";}}
  '';
  "abstractions/p11-kit" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/p11-kit"
    ${etcRule {path="pkcs11"; trail="/";}}
    ${etcRule {path="pkcs11"; trail="/pkcs11.conf";}}
    ${etcRule {path="pkcs11"; trail="/modules/";}}
    ${etcRule {path="pkcs11"; trail="/modules/*";}}
  '';
  "abstractions/perl" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/perl"
    ${etcRule {path="perl"; trail="/**";}}
  '';
  "abstractions/php" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/php"
    ${etcRule {path="php"; trail="/**/";}}
    ${etcRule {path="php5"; trail="/**/";}}
    ${etcRule {path="php7"; trail="/**/";}}
    ${etcRule {path="php"; trail="/**.ini";}}
    ${etcRule {path="php5"; trail="/**.ini";}}
    ${etcRule {path="php7"; trail="/**.ini";}}
  '';
  "abstractions/postfix-common" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/postfix-common"
    ${etcRule "mailname"}
    ${etcRule {path="postfix"; trail="/*.cf";}}
    ${etcRule "postfix/main.cf"}
    ${etcRule "postfix/master.cf"}
  '';
  "abstractions/python" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/python"
  '';
  "abstractions/qt5" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/qt5"
    ${etcRule {path="xdg"; trail="/QtProject/qtlogging.ini";}}
    ${etcRule {path="xdg/QtProject"; trail="/qtlogging.ini";}}
    ${etcRule "xdg/QtProject/qtlogging.ini"}
  '';
  "abstractions/samba" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/samba"
    ${etcRule {path="samba"; trail="/*";}}
  '';
  "abstractions/ssl_certs" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/ssl_certs"
    ${etcRule "ssl/certs/ca-certificates.crt"}
    ${etcRule "ssl/certs/ca-bundle.crt"}
    ${etcRule "pki/tls/certs/ca-bundle.crt"}

    ${etcRule {path="ssl/trust"; trail="/";}}
    ${etcRule {path="ssl/trust"; trail="/*";}}
    ${etcRule {path="ssl/trust/anchors"; trail="/";}}
    ${etcRule {path="ssl/trust/anchors"; trail="/**";}}
    ${etcRule {path="pki/trust"; trail="/";}}
    ${etcRule {path="pki/trust"; trail="/*";}}
    ${etcRule {path="pki/trust/anchors"; trail="/";}}
    ${etcRule {path="pki/trust/anchors"; trail="/**";}}

    # security.acme NixOS module
    r /var/lib/acme/*/cert.pem,
    r /var/lib/acme/*/chain.pem,
    r /var/lib/acme/*/fullchain.pem,
  '';
  "abstractions/ssl_keys" = ''
    # security.acme NixOS module
    r /var/lib/acme/*/full.pem,
    r /var/lib/acme/*/key.pem,
  '';
  "abstractions/vulkan" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/vulkan"
    ${etcRule {path="vulkan/icd.d"; trail="/";}}
    ${etcRule {path="vulkan/icd.d"; trail="/*.json";}}
  '';
  "abstractions/winbind" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/winbind"
    ${etcRule {path="samba"; trail="/smb.conf";}}
    ${etcRule {path="samba"; trail="/dhcp.conf";}}
  '';
  "abstractions/X" = ''
    include "${pkgs.apparmor-profiles}/etc/apparmor.d/abstractions/X"
    ${etcRule {path="X11/cursors"; trail="/";}}
    ${etcRule {path="X11/cursors"; trail="/**";}}
  '';
};
}
