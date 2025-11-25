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
    "24.05.0" = {
      major = "24";
      minor = "5";
      patch = "0";
      hash = "sha256-pye2JOilSbp8PFCpVXFkrRW98E8klCqoisVSWjR38nE=";
      suffix = "76";
      homepage = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest1.html";
    };

    "24.08.0" = {
      major = "24";
      minor = "8";
      patch = "0";
      hash = "1jb22n6gcv4pv8khg98sv663yfpi47dpkvqgifbhps98iw5zrkbp";
      suffix = "98";
      homepage = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest-2408.html";
    };

    "24.11.0" = {
      major = "24";
      minor = "11";
      patch = "0";
      hash = "0kylvqdzkw0635mbb6r5k1lamdjf1hr9pk5rxcff63z4f8q0g3zf";
      suffix = "85";
      homepage = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest13.html";
    };

    "25.03.0" = {
      major = "25";
      minor = "03";
      patch = "0";
      hash = "052zibykhig9091xl76z2x9vn4f74w5q8i9frlpc473pvfplsczk";
      suffix = "66";
      homepage = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest-2503.html";
    };

    "25.05.0" = {
      major = "25";
      minor = "05";
      patch = "0";
      hash = "0fwqsxggswms40b5k8saxpm1ghkxppl27x19w8jcslq1f0i1fwqx";
      suffix = "44";
      homepage = "https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html";
    };
  };
in
supportedVersions
