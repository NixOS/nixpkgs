{ stdenv, lib }:

let
  mkVersionInfo =
    _:
    {
      major,
      minor,
      patch,
      hash,
      suffix,
      homepage,
    }:
    {
      inherit hash homepage;
      version = "${major}.${minor}.${patch}.${suffix}";
    };

  # Attribute-set with all actively supported versions of the Citrix workspace app
  # for Linux.
  #
  # The latest versions can be found at https://www.citrix.com/downloads/workspace-app/linux/
  supportedVersions = lib.mapAttrs mkVersionInfo {
    "25.08.10" = {
      major = "25";
      minor = "08";
      patch = "10";
      hash = "06hdwi5rd8z43nlpvym6yrw3snfz8jh6ic3g4pihn9ji22bw5pbd";
      suffix = "111";
      homepage = "https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html";
    };
  };
in
supportedVersions
