{ stdenv, buildEnv, fetchurl, mono, unzip }:

let
  version = "1.6.3";
  drv = stdenv.mkDerivation {
    name = "keefox-${version}";
    src = fetchurl {
      url    = "https://github.com/luckyrat/KeeFox/releases/download/v${version}/${version}.xpi";
      sha256 = "dc26c51a6b3690d4bec527c3732a72f67a85b804c60db5e699260552e2dd2bd9";
    };

    meta = {
      description = "Keepass plugin for keefox Firefox add-on";
      homepage    = http://keefox.org;
      platforms   = with stdenv.lib.platforms; linux;
      license     = stdenv.lib.licenses.gpl2;
    };

    buildInputs = [ unzip ];

    pluginFilename = "KeePassRPC.plgx";

    unpackCmd = "unzip $src deps/$pluginFilename ";
    sourceRoot = "deps";

    installPhase = ''
      mkdir -p $out/lib/dotnet/keepass/
      cp $pluginFilename $out/lib/dotnet/keepass/$pluginFilename
    '';
  };
in
  # Mono is required to compile plugin at runtime, after loading.
  buildEnv { name = drv.name; paths = [ mono drv ]; }
