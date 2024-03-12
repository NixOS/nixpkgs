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
  # The latest versions can be found at https://www.citrix.com/downloads/workspace-app/linux/
  supportedVersions = lib.mapAttrs mkVersionInfo {

    "23.02.0" = {
      major     = "23";
      minor     = "2";
      patch     = "0";
      x64hash   = "d0030a4782ba4b2628139635a12a7de044a4eb36906ef1eadb05b6ea77c1a7bc";
      x86hash   = "39228fc8dd69adca4e56991c1ebc0832fec183c3ab5abd2d65c66b39b634391b";
      x64suffix = "10";
      x86suffix = "10";
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest6.html";
    };

    "23.07.0" = {
      major     = "23";
      minor     = "7";
      patch     = "0";
      x64hash   = "d4001226e79b5353fc74da4c8ed4f6295c1859fe18142cb5de345a3c7ae48168";
      x86hash   = "4a7da238286ae28d7baf0fefa1e7e09d077c8bc56c2bf7bec00da42c331bee59";
      x64suffix = "17";
      x86suffix = "17";
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest21.html";
    };

    "23.09.0" = {
      major     = "23";
      minor     = "9";
      patch     = "0";
      x64hash   = "7b06339654aa27258d6dfa922828b43256e780b282d07109f452246c7aa27514";
      x86hash   = "95436fb289602cf31c65b7df89da145fc170233cb2e758a2f11116f15b57d382";
      x64suffix = "24";
      x86suffix = "24";
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest9.html";
    };

    "23.11.0" = {
      major     = "23";
      minor     = "11";
      patch     = "0";
      x64hash   = "d3dde64baa6db7675a025eff546d552544d3523f4f3047621884f7830a9e2822";
      x86hash   = "65b8c144e51b5bd78b98ae69e0fa76d6c020a857d74fd5254be49492527072b6";
      x64suffix = "82";
      x86suffix = "82";
      homepage  = "https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html";
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
