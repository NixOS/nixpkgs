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
    "21.01.0" = {
      major     = "21";
      minor     = "1";
      patch     = "0";
      x64hash   = "01m9g1bs6iiqbd778gjps2zznvqijlyn3mfw38aa0w1rr6ms326a";
      x86hash   = "1mmx5r3wi9i6bwh4kdlpw446m8kijkaar8shi0q1n21fv0ygg3r5";
      x64suffix = "14";
      x86suffix = "14";
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-2101.html";
    };

    "21.03.0" = {
      major     = "21";
      minor     = "3";
      patch     = "0";
      x64hash   = "004pgvxl81l99sqvrs5xzvjivjlc21rrlm2gky9hmbsm53nsl3zc";
      x86hash   = "11nn9734a515dm1q880z9wmhvx8ikyh3riayyn42z22q4kd852n3";
      x64suffix = "38";
      x86suffix = "38";
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-2103.html";
    };

    "21.06.0" = {
      major     = "21";
      minor     = "6";
      patch     = "0";
      x64hash   = "f3f98c60b0aaac31eb44dc98f22ee7ae7df229c960d5d29785eb5e9554f85f68";
      x86hash   = "c2d9652ad9488a9ff171e62df8455ebe6890bcfade1cc289893ee35322d9d812";
      x64suffix = "28";
      x86suffix = "28";
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-2106.html";
    };

    "21.08.0" = {
      major     = "21";
      minor     = "8";
      patch     = "0";
      x64hash   = "69ddae29cc8b4b68341c3d9503a54ee70ab58a5795fd83e79573f013eda5518c";
      x86hash   = "b6d1bde5a8533f22374e1f5bbb3f5949e5b89773d0703e021fbe784b455aad3f";
      x64suffix = "40";
      x86suffix = "40";
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-2108.html";
    };

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
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest5.html";
    };

    "23.02.0" = {
      major     = "23";
      minor     = "2";
      patch     = "0";
      x64hash   = "d0030a4782ba4b2628139635a12a7de044a4eb36906ef1eadb05b6ea77c1a7bc";
      x86hash   = "39228fc8dd69adca4e56991c1ebc0832fec183c3ab5abd2d65c66b39b634391b";
      x64suffix = "10";
      x86suffix = "10";
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
