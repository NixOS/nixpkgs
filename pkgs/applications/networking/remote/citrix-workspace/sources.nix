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
      version = "${major}.${minor}.${patch}.${
        if stdenv.hostPlatform.is64bit then x64suffix else x86suffix
      }";
      prefix = "linuxx${if stdenv.hostPlatform.is64bit then "64" else "86"}";
      hash = if stdenv.hostPlatform.is64bit then x64hash else x86hash;
    };

  # Attribute-set with all actively supported versions of the Citrix workspace app
  # for Linux.
  #
  # The latest versions can be found at https://www.citrix.com/downloads/workspace-app/linux/
  # x86 is unsupported past 23.11, see https://docs.citrix.com/en-us/citrix-workspace-app-for-linux/deprecation
  supportedVersions = lib.mapAttrs mkVersionInfo {

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
      homepage = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest1.html";
    };

    "24.08.0" = {
      major = "24";
      minor = "8";
      patch = "0";
      x64hash = "1jb22n6gcv4pv8khg98sv663yfpi47dpkvqgifbhps98iw5zrkbp";
      x86hash = "";
      x64suffix = "98";
      x86suffix = "";
      homepage = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest-2408.html";
    };

    "24.11.0" = {
      major = "24";
      minor = "11";
      patch = "0";
      x64hash = "0kylvqdzkw0635mbb6r5k1lamdjf1hr9pk5rxcff63z4f8q0g3zf";
      x86hash = "";
      x64suffix = "85";
      x86suffix = "";
      homepage = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest13.html";
    };

    "25.03.0" = {
      major = "25";
      minor = "03";
      patch = "0";
      x64hash = "052zibykhig9091xl76z2x9vn4f74w5q8i9frlpc473pvfplsczk";
      x86hash = "";
      x64suffix = "66";
      x86suffix = "";
      homepage = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest-2503.html";
    };

    "25.05.0" = {
      major = "25";
      minor = "05";
      patch = "0";
      x64hash = "0fwqsxggswms40b5k8saxpm1ghkxppl27x19w8jcslq1f0i1fwqx";
      x86hash = "";
      x64suffix = "44";
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
    "23.09.0"
  ];
in
{
  inherit supportedVersions unsupportedVersions;
}
