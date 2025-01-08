{ lib, ... }:

let
  inherit (lib)
    mkAliasOptionModuleMD
    mkRemovedOptionModule
    ;
in
{
  imports = [
    /*
      This file defines some renaming/removing options for backwards compatibility

      It should ONLY be used when the relevant module can't define these imports
      itself, such as when the module was removed completely.
      See https://github.com/NixOS/nixpkgs/pull/61570 for explanation
    */

    # This alias module can't be where _module.check is defined because it would
    # be added to submodules as well there
    (mkAliasOptionModuleMD [ "environment" "checkConfigurationOptions" ] [ "_module" "check" ])

    # Completely removed modules
    (lib.mkRemovedOptionModule [ "boot" "loader" "raspberryPi" ]
      "The raspberryPi boot loader has been removed. See https://github.com/NixOS/nixpkgs/pull/241534 for what to use instead."
    )
    (lib.mkRemovedOptionModule [ "environment" "blcr" "enable" ] "The BLCR module has been removed")
    (lib.mkRemovedOptionModule [ "environment" "noXlibs" ] ''
      The environment.noXlibs option was removed, as it often caused surprising breakages for new users.
      If you need its functionality, you can apply similar overlays in your own config.
    '')
    (lib.mkRemovedOptionModule [
      "fonts"
      "fontconfig"
      "penultimate"
    ] "The corresponding package has removed from nixpkgs.")
    (lib.mkRemovedOptionModule [ "hardware" "brightnessctl" ] ''
      The brightnessctl module was removed because newer versions of
      brightnessctl don't require the udev rules anymore (they can use the
      systemd-logind API). Instead of using the module you can now
      simply add the brightnessctl package to environment.systemPackages.
    '')
    (lib.mkRemovedOptionModule [ "hardware" "gkraken" "enable" ] ''
      gkraken was deprecated by coolercontrol and thus removed from nixpkgs.
      Consider using programs.coolercontrol instead.
    '')
    (lib.mkRemovedOptionModule [ "hardware" "u2f" ] ''
      The U2F modules module was removed, as all it did was adding the
      udev rules from libu2f-host to the system. Udev gained native support
      to handle FIDO security tokens, so this isn't necessary anymore.
    '')
    (lib.mkRemovedOptionModule [ "hardware" "xow" ] ''
      The xow package was removed from nixpkgs. Upstream has deprecated
      the project and users are urged to switch to xone.
    '')
    (lib.mkRemovedOptionModule [ "networking" "vpnc" ] "Use environment.etc.\"vpnc/service.conf\" instead.")
    (lib.mkRemovedOptionModule [
      "networking"
      "wicd"
    ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [
      "programs"
      "gnome-documents"
    ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [ "programs" "pantheon-tweaks" ] ''
      pantheon-tweaks is no longer a switchboard plugin but an independent app,
      adding the package to environment.systemPackages is sufficient.
    '')
    (lib.mkRemovedOptionModule [ "programs" "tilp2" ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [ "programs" "way-cooler" ] (
      "way-cooler is abandoned by its author: "
      + "https://way-cooler.org/blog/2020/01/09/way-cooler-post-mortem.html"
    ))
    (lib.mkRemovedOptionModule [ "security" "hideProcessInformation" ] ''
      The hidepid module was removed, since the underlying machinery
      is broken when using cgroups-v2.
    '')
    (lib.mkRemovedOptionModule [ "services" "antennas" ]
      "The antennas package and the corresponding module have been removed as they only work with tvheadend, which nobody was willing to maintain and was stuck on an unmaintained version that required FFmpeg 4; please see https://github.com/NixOS/nixpkgs/pull/332259 if you are interested in maintaining a newer version."
    )
    (lib.mkRemovedOptionModule [
      "services"
      "anbox"
    ] "The corresponding package was removed from nixpkgs as it is not maintained upstream anymore.")
    (lib.mkRemovedOptionModule [
      "services"
      "ankisyncd"
    ] "`services.ankisyncd` has been replaced by `services.anki-sync-server`.")
    (lib.mkRemovedOptionModule [
      "services"
      "baget"
      "enable"
    ] "The baget module was removed due to the upstream package being unmaintained.")
    (lib.mkRemovedOptionModule [ "services" "beegfs" ] "The BeeGFS module has been removed")
    (lib.mkRemovedOptionModule [ "services" "beegfsEnable" ] "The BeeGFS module has been removed")
    (lib.mkRemovedOptionModule [
      "services"
      "cgmanager"
      "enable"
    ] "cgmanager was deprecated by lxc and therefore removed from nixpkgs.")
    (lib.mkRemovedOptionModule [
      "services"
      "chronos"
    ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [ "services" "confluence" ]
      "Atlassian software has been removed, as support for the Atlassian Server products ended in February 2024 and there was insufficient interest in maintaining the Atlassian Data Center replacements"
    )
    (lib.mkRemovedOptionModule [
      "services"
      "couchpotato"
    ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [ "services" "crowd" ]
      "Atlassian software has been removed, as support for the Atlassian Server products ended in February 2024 and there was insufficient interest in maintaining the Atlassian Data Center replacements"
    )
    (lib.mkRemovedOptionModule [
      "services"
      "dd-agent"
    ] "dd-agent was removed from nixpkgs in favor of the newer datadog-agent.")
    (lib.mkRemovedOptionModule [ "services" "dnscrypt-proxy" ] "Use services.dnscrypt-proxy2 instead")
    (lib.mkRemovedOptionModule [ "services" "dnscrypt-wrapper" ] ''
      The dnscrypt-wrapper module was removed since the project has been effectively unmaintained since 2018;
      moreover the NixOS module had to rely on an abandoned version of dnscrypt-proxy v1 for the rotation of keys.

      To wrap a resolver with DNSCrypt you can instead use dnsdist. See options `services.dnsdist.dnscrypt.*`
    '')
    (lib.mkRemovedOptionModule [
      "services"
      "exhibitor"
    ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [
      "services"
      "firefox"
      "syncserver"
    ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [
      "services"
      "flashpolicyd"
    ] "The flashpolicyd module has been removed. Adobe Flash Player is deprecated.")
    (lib.mkRemovedOptionModule [ "services" "fourStore" ] "The fourStore module has been removed")
    (lib.mkRemovedOptionModule [
      "services"
      "fourStoreEndpoint"
    ] "The fourStoreEndpoint module has been removed")
    (lib.mkRemovedOptionModule [ "services" "fprot" ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [ "services" "frab" ] "The frab module has been removed")
    (lib.mkRemovedOptionModule [ "services" "homeassistant-satellite" ]
      "The `services.homeassistant-satellite` module has been replaced by `services.wyoming-satellite`."
    )
    (lib.mkRemovedOptionModule [ "services" "hydron" ]
      "The `services.hydron` module has been removed as the project has been archived upstream since 2022 and is affected by a severe remote code execution vulnerability."
    )
    (lib.mkRemovedOptionModule [
      "services"
      "ihatemoney"
    ] "The ihatemoney module has been removed for lack of downstream maintainer")
    (lib.mkRemovedOptionModule [ "services" "jira" ]
      "Atlassian software has been removed, as support for the Atlassian Server products ended in February 2024 and there was insufficient interest in maintaining the Atlassian Data Center replacements"
    )
    (lib.mkRemovedOptionModule [ "services" "kippo" ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [ "services" "lshd" ]
      "The corresponding package was removed from nixpkgs as it had no maintainer in Nixpkgs and hasn't seen an upstream release in over a decades."
    )
    (lib.mkRemovedOptionModule [
      "services"
      "mailpile"
    ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [
      "services"
      "marathon"
    ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [ "services" "mathics" ] "The Mathics module has been removed")
    (lib.mkRemovedOptionModule [ "services" "matrix-sliding-sync" ]
      "The matrix-sliding-sync package has been removed, since matrix-synapse incorporated its functionality. Remove `services.sliding-sync` from your NixOS Configuration, and the `.well-known` record for `org.matrix.msc3575.proxy` from your webserver"
    )
    (lib.mkRemovedOptionModule [ "services" "meguca" ] "Use meguca has been removed from nixpkgs")
    (lib.mkRemovedOptionModule [ "services" "mesos" ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [
      "services"
      "mxisd"
    ] "The mxisd module has been removed as both mxisd and ma1sd got removed.")
    (lib.mkRemovedOptionModule [
      "services"
      "moinmoin"
    ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [ "services" "mwlib" ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [ "services" "pantheon" "files" ] ''
      This module was removed, please add pkgs.pantheon.elementary-files to environment.systemPackages directly.
    '')
    (lib.mkRemovedOptionModule [ "services" "prey" ] ''
      prey-bash-client is deprecated upstream
    '')
    (lib.mkRemovedOptionModule [
      "services"
      "quagga"
    ] "the corresponding package has been removed from nixpkgs")
    (lib.mkRemovedOptionModule [
      "services"
      "railcar"
    ] "the corresponding package has been removed from nixpkgs")
    (lib.mkRemovedOptionModule [ "services" "replay-sorcery" ]
      "the corresponding package has been removed from nixpkgs as it is unmaintained upstream. Consider using `gpu-screen-recorder` or `obs-studio` instead."
    )
    (lib.mkRemovedOptionModule [ "services" "seeks" ] "")
    (lib.mkRemovedOptionModule [
      "services"
      "shout"
    ] "shout was removed because it was deprecated upstream in favor of thelounge.")
    (lib.mkRemovedOptionModule [ "services" "ssmtp" ] ''
      The ssmtp package and the corresponding module have been removed due to
      the program being unmaintained. The options `programs.msmtp.*` can be
      used instead.
    '')
    (lib.mkRemovedOptionModule [ "services" "tvheadend" ]
      "The tvheadend package and the corresponding module have been removed as nobody was willing to maintain them and they were stuck on an unmaintained version that required FFmpeg 4; please see https://github.com/NixOS/nixpkgs/pull/332259 if you are interested in maintaining a newer version."
    )
    (lib.mkRemovedOptionModule [ "services" "unifi-video" ]
      "The unifi-video package and the corresponding module have been removed as the software has been unsupported since 2021 and requires a MongoDB version that has reached end of life."
    )
    (lib.mkRemovedOptionModule [ "services" "venus" ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [
      "services"
      "wakeonlan"
    ] "This module was removed in favor of enabling it with networking.interfaces.<name>.wakeOnLan")
    (lib.mkRemovedOptionModule [
      "services"
      "winstone"
    ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [ "services" "xserver" "displayManager" "auto" ] ''
      The services.xserver.displayManager.auto module has been removed
      because it was only intended for use in internal NixOS tests, and gave the
      false impression of it being a special display manager when it's actually
      LightDM. Please use the services.displayManager.autoLogin options
      instead, or any other display manager in NixOS as they all support auto-login.
    '')
    (lib.mkRemovedOptionModule [ "services" "xserver" "multitouch" ] ''
      services.xserver.multitouch (which uses xf86_input_mtrack) has been removed
      as the underlying package isn't being maintained. Working alternatives are
      libinput and synaptics.
    '')
    (lib.mkRemovedOptionModule [
      "services"
      "xmr-stak"
    ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [
      "virtualisation"
      "rkt"
    ] "The rkt module has been removed, it was archived by upstream")
    (lib.mkRemovedOptionModule [ "services" "racoon" ] ''
      The racoon module has been removed, because the software project was abandoned upstream.
    '')
    (lib.mkRemovedOptionModule [
      "services"
      "shellinabox"
    ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [
      "services"
      "gogoclient"
    ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [
      "services"
      "virtuoso"
    ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [
      "services"
      "openfire"
    ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [ "services" "riak" ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [ "services" "rtsp-simple-server" ]
      "Package has been completely rebranded by upstream as mediamtx, and thus the service and the package were renamed in NixOS as well."
    )
    (lib.mkRemovedOptionModule [
      "services"
      "prayer"
    ] "The corresponding package was removed from nixpkgs.")
    (lib.mkRemovedOptionModule [
      "services"
      "restya-board"
    ] "The corresponding package was removed from nixpkgs.")

    (lib.mkRemovedOptionModule [
      "i18n"
      "inputMethod"
      "fcitx"
    ] "The fcitx module has been removed. Please use fcitx5 instead")
    (lib.mkRemovedOptionModule [ "services" "dhcpd4" ] ''
      The dhcpd4 module has been removed because ISC DHCP reached its end of life.
      See https://www.isc.org/blogs/isc-dhcp-eol/ for details.
      Please switch to a different implementation like kea or dnsmasq.
    '')
    (lib.mkRemovedOptionModule [ "services" "dhcpd6" ] ''
      The dhcpd6 module has been removed because ISC DHCP reached its end of life.
      See https://www.isc.org/blogs/isc-dhcp-eol/ for details.
      Please switch to a different implementation like kea or dnsmasq.
    '')
    (lib.mkRemovedOptionModule [ "services" "tedicross" ] ''
      The corresponding package was broken and removed from nixpkgs.
    '')

    # Do NOT add any option renames here, see top of the file
  ];
}
