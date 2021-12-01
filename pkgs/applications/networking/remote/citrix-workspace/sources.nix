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
    "20.04.0" = {
      major     = "20";
      minor     = "04";
      patch     = "0";
      x64hash   = "E923592216F9541173846F932784E6C062CB09C9E8858219C7489607BF82A0FB";
      x86hash   = "A2E2E1882723DA6796E68916B3BB2B44DD575A83DEB03CA90A262F6C81B1A53F";
      x64suffix = "21";
      x86suffix = "21";
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-2004.html";
    };

    "20.06.0" = {
      major     = "20";
      minor     = "06";
      patch     = "0";
      x64hash   = "1kpfcfg95mpprlca6cccnjlsqbj3xvv77cn3fc5msd304nsi9x1v";
      x86hash   = "1di29hrimbw3myjnf2nn26a14klidhdwvjqla6yxhwd3s6lil194";
      x64suffix = "15";
      x86suffix = "15";
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-2006.html";
    };

    "20.09.0" = {
      major     = "20";
      minor     = "9";
      patch     = "0";
      x64hash   = "15gjq1vk1y76c39p72xnam9h9rnr0632i4n11l6xbjnfnad8d4pr";
      x86hash   = "1b4gdmnnpa61ydiv2fnmap8cnfhskrq6swcs6i1nqrp5zvvkqrv4";
      x64suffix = "15";
      x86suffix = "15";
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-2009.html";
    };

    "20.10.0" = {
      major     = "20";
      minor     = "10";
      patch     = "0";
      x64hash   = "13g7r92mhwqwqkm6a4k4yn232ighkmxifs7j8wdi1yva0dvklqdf";
      x86hash   = "04cr2da25v8x098ccyjwa47d4krk3jpldqkyf4kk2j3hwzbqh9yx";
      x64suffix = "6";
      x86suffix = "6";
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-2010.html";
    };

    "20.12.0" = {
      major     = "20";
      minor     = "12";
      patch     = "0";
      x64hash   = "1268nriqjp27nxqqi4dvkv8r01yj3bhglxv21xd185761da2mzry";
      x86hash   = "0f982d5y9k4hscqfmqpfs277cqw1pvp191ybvg5p8rxk12fh67vf";
      x64suffix = "12";
      x86suffix = "12";
      homepage  = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-2012.html";
    };

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
