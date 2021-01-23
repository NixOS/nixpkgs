{ stdenv, lib }:

let
  mkVersionInfo = _: { major, minor, patch, x64hash, x86hash, x64suffix, x86suffix, homepage }:
    { inherit homepage;
      version = "${major}.${minor}.${patch}.${if stdenv.is64bit then x64suffix else x86suffix}";
      prefix = "linuxx${if stdenv.is64bit then "64" else "86"}";
      hash = if stdenv.is64bit then x64hash else x86hash;
    };

  # Attribute-set with all actively supported versions of the Citrix workspace app
  # for Linux.
  #
  # The latest versions can be found at https://www.citrix.com/de-de/downloads/workspace-app/linux/
  supportedVersions = lib.mapAttrs mkVersionInfo {
    "20.04.0" = {
      major     = "20";
      minor     = "04";
      patch     = "0";
      x64hash   = "E923592216F9541173846F932784E6C062CB09C9E8858219C7489607BF82A0FB";
      x86hash   = "A2E2E1882723DA6796E68916B3BB2B44DD575A83DEB03CA90A262F6C81B1A53F";
      x64suffix = "21";
      x86suffix = "21";
      homepage  = "https://www.citrix.com/de-de/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-2004.html";
    };

    "20.06.0" = {
      major     = "20";
      minor     = "06";
      patch     = "0";
      x64hash   = "1kpfcfg95mpprlca6cccnjlsqbj3xvv77cn3fc5msd304nsi9x1v";
      x86hash   = "1di29hrimbw3myjnf2nn26a14klidhdwvjqla6yxhwd3s6lil194";
      x64suffix = "15";
      x86suffix = "15";
      homepage  = "https://www.citrix.com/de-de/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-2006.html";
    };

    "20.09.0" = {
      major     = "20";
      minor     = "9";
      patch     = "0";
      x64hash   = "15gjq1vk1y76c39p72xnam9h9rnr0632i4n11l6xbjnfnad8d4pr";
      x86hash   = "1b4gdmnnpa61ydiv2fnmap8cnfhskrq6swcs6i1nqrp5zvvkqrv4";
      x64suffix = "15";
      x86suffix = "15";
      homepage  = "https://www.citrix.com/de-de/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-2009.html";
    };

    "20.10.0" = {
      major     = "20";
      minor     = "10";
      patch     = "0";
      x64hash   = "13g7r92mhwqwqkm6a4k4yn232ighkmxifs7j8wdi1yva0dvklqdf";
      x86hash   = "04cr2da25v8x098ccyjwa47d4krk3jpldqkyf4kk2j3hwzbqh9yx";
      x64suffix = "6";
      x86suffix = "6";
      homepage  = "https://www.citrix.com/de-de/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-2010.html";
    };

    "20.12.0" = {
      major     = "20";
      minor     = "12";
      patch     = "0";
      x64hash   = "1268nriqjp27nxqqi4dvkv8r01yj3bhglxv21xd185761da2mzry";
      x86hash   = "0f982d5y9k4hscqfmqpfs277cqw1pvp191ybvg5p8rxk12fh67vf";
      x64suffix = "12";
      x86suffix = "12";
      homepage  = "https://www.citrix.com/de-de/downloads/workspace-app/linux/workspace-app-for-linux-latest.html";
    };
  };

  # Retain attribute-names for abandoned versions of Citrix workspace to
  # provide a meaningful error-message if it's attempted to use such an old one.
  #
  # The lifespans of Citrix products can be found here:
  # https://www.citrix.com/support/product-lifecycle/milestones/receiver.html
  unsupportedVersions = [ ];
in {
  inherit supportedVersions unsupportedVersions;
}
