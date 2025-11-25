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
    "25.08.0" = {
      major = "25";
      minor = "08";
      patch = "0";
      hash = "19nx7j78c84m6wlidkaicqf5rgy05rm85vzh3admhrl8q9zr1avr";
      suffix = "88";
      homepage = "https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html";
    };
  };
in
supportedVersions
