{ stdenv, buildEnv, fetchurl, mono, unzip }:

let
  version = "1.5.4";
  drv = stdenv.mkDerivation {
    name = "keefox-${version}";
    src = fetchurl {
      url    = "https://github.com/luckyrat/KeeFox/releases/download/v${version}/${version}.xpi";
      sha256 = "c7c30770beb0ea32cbdee5311d03a9910fb7772695af3aa655e4ae64cd4d8335";
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
