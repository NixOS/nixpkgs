{ stdenv, lib }:

let
  mkVersionInfo =
    _:
    {
      major,
      minor,
      patch,
      x64hash,
      x86hash,
      x64suffix,
      x86suffix,
      homepage,
    }:
    {
      inherit homepage;
      version = "${major}.${minor}.${patch}.${if stdenv.is64bit then x64suffix else x86suffix}";
      prefix = "linuxx${if stdenv.is64bit then "64" else "86"}";
      hash = if stdenv.is64bit then x64hash else x86hash;
    };

  # Attribute-set with all actively supported versions of the Citrix workspace app
  # for Linux.
  #
  # The latest versions can be found at https://www.citrix.com/downloads/workspace-app/linux/
  # x86 is unsupported past 23.11, see https://docs.citrix.com/en-us/citrix-workspace-app-for-linux/deprecation
  supportedVersions = lib.mapAttrs mkVersionInfo {
    "23.09.0" = {
      major = "23";
      minor = "9";
      patch = "0";
      x64hash = "7b06339654aa27258d6dfa922828b43256e780b282d07109f452246c7aa27514";
      x86hash = "95436fb289602cf31c65b7df89da145fc170233cb2e758a2f11116f15b57d382";
      x64suffix = "24";
      x86suffix = "24";
      homepage = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest9.html";
    };

    "23.11.0" = {
      major = "23";
      minor = "11";
      patch = "0";
      x64hash = "d3dde64baa6db7675a025eff546d552544d3523f4f3047621884f7830a9e2822";
      x86hash = "65b8c144e51b5bd78b98ae69e0fa76d6c020a857d74fd5254be49492527072b6";
      x64suffix = "82";
      x86suffix = "82";
      homepage = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest10.html";
    };

    "24.02.0" = {
      major = "24";
      minor = "2";
      patch = "0";
      x64hash = "eaeb5d3bd079d4e5c9707da67f5f7a25cb765e19c36d01861290655dbf2aaee4";
      x86hash = "";
      x64suffix = "65";
      x86suffix = "";
      homepage = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest12.html";
    };

    "24.05.0" = {
      major = "24";
      minor = "5";
      patch = "0";
      x64hash = "sha256-pye2JOilSbp8PFCpVXFkrRW98E8klCqoisVSWjR38nE=";
      x86hash = "";
      x64suffix = "76";
      x86suffix = "";
      homepage = "https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html";
    };
  };

  # Retain attribute-names for abandoned versions of Citrix workspace to
  # provide a meaningful error-message if it's attempted to use such an old one.
  #
  # The lifespans of Citrix products can be found here:
  # https://www.citrix.com/support/product-lifecycle/workspace-app.html
  unsupportedVersions = [
    "23.02.0"
    "23.07.0"
  ];
in
{
  inherit supportedVersions unsupportedVersions;
}
