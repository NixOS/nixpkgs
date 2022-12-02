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

    "21.09.0" = {
      major     = "21";
      minor     = "9";
      patch     = "0";
      x64hash   = "d58d5cbbcb5ace95b75b1400061d475b8e72dbdf5f03abacea6d39686991f848";
      x86hash   = "c646c52889e88aa0bb051070076763d5407f21fb6ad6dfcb0fe635ac01180c51";
      x64suffix = "25";
      x86suffix = "25";
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-2109.html";
    };

    "21.12.0" = {
      major     = "21";
      minor     = "12";
      patch     = "0";
      x64hash   = "de81deab648e1ebe0ddb12aa9591c8014d7fad4eba0db768f25eb156330bb34d";
      x86hash   = "3746cdbe26727f7f6fb85fbe5f3e6df0322d79bb66e3a70158b22cb4f6b6b292";
      x64suffix = "18";
      x86suffix = "18";
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-2112.html";
    };

    "22.05.0" = {
      major     = "22";
      minor     = "5";
      patch     = "0";
      x64hash   = "49786fd3b5361b1f42b7bb0e36572a209e95acb1335737da5216345b6420f053";
      x86hash   = "f2dc1fd64e5314b62ba87f384958c2bbd48b06b55bed10345cddb05fdc8cffa1";
      x64suffix = "16";
      x86suffix = "16";
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest2.html";
    };

    "22.07.0" = {
      major     = "22";
      minor     = "7";
      patch     = "0";
      x64hash   = "ba88490e457e0fe6c610778396e40293067173c182f2343c8c1fda5e2444985c";
      x86hash   = "ed9ff8b3be968cacaf6121c783326091899b987e53fac1aafae68ea3e5883403";
      x64suffix = "14";
      x86suffix = "14";
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest-OLD1.html";
    };

    "22.12.0" = {
      major     = "22";
      minor     = "12";
      patch     = "0";
      x64hash   = "3ec5a3d5526a6bac17bb977b173542f5bdd535a53baa6dca80c83a0d61229d74";
      x86hash   = "b73f90fe51bbb7391c188a394ea614b67f128ed0d9481bd7824cbcadc0338dae";
      x64suffix = "12";
      x86suffix = "12";
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
