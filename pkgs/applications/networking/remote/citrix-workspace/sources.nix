{ lib }:

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
    "26.04.0" = {
      major = "26";
      minor = "04";
      patch = "0";
      hash = "1hp6ax0ix3id94njd43a35af3ydlb6sqwvbbabd5xp8d511m695f";
      suffix = "73";
      homepage = "https://www.citrix.com/downloads/workspace-app/betas-and-tech-previews/workspace-app-tp-gcc11-for-linux.html";
    };
  };
in
supportedVersions
