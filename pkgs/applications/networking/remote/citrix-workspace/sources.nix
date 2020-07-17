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
    "19.12.0" = {
      major     = "19";
      minor     = "12";
      patch     = "0";
      x64hash   = "1si5mkxbgb8m99bkvgc3l80idjfdp0kby6pv47s07nn43dbr1j7a";
      x86hash   = "07rfp90ksnvr8zv7ix7f0z6a59n48s7bd4kqbzilfwxgs4ddqmcy";
      x64suffix = "19";
      x86suffix = "19";
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-1912.html";
    };

    "20.04.0" = {
      major     = "20";
      minor     = "04";
      patch     = "0";
      x64hash   = "E923592216F9541173846F932784E6C062CB09C9E8858219C7489607BF82A0FB";
      x86hash   = "A2E2E1882723DA6796E68916B3BB2B44DD575A83DEB03CA90A262F6C81B1A53F";
      x64suffix = "21";
      x86suffix = "21";
      homepage  = "https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html";
    };

    "20.06.0" = {
      major     = "20";
      minor     = "06";
      patch     = "0";
      x64hash   = "1kpfcfg95mpprlca6cccnjlsqbj3xvv77cn3fc5msd304nsi9x1v";
      x86hash   = "1di29hrimbw3myjnf2nn26a14klidhdwvjqla6yxhwd3s6lil194";
      x64suffix = "15";
      x86suffix = "15";
      homepage  = "https://www.citrix.com/de-de/downloads/workspace-app/linux/workspace-app-for-linux-latest.html";
    };
  };

  # Retain attribute-names for abandoned versions of Citrix workspace to
  # provide a meaningful error-message if it's attempted to use such an old one.
  #
  # The lifespans of Citrix products can be found here:
  # https://www.citrix.com/support/product-lifecycle/milestones/receiver.html
  unsupportedVersions = [ "19.6.0" "19.8.0" "19.10.0" ];
in {
  inherit supportedVersions unsupportedVersions;
}
