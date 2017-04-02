{ stdenv, buildEnv, fetchurl, mono, unzip }:

let
  version = "1.6.4";
  drv = stdenv.mkDerivation {
    name = "keefox-${version}";
    src = fetchurl {
      url    = "https://github.com/luckyrat/KeeFox/releases/download/v${version}/${version}.xpi";
      sha256 = "0nj4l9ssyfwbl1pxgxvd2h9q0mqhx7i0yzm4a2xjqlqwam534d1w";
    };

    meta = {
      description = "Keepass plugin for keefox Firefox add-on";
      homepage    = http://keefox.org;
      platforms   = with stdenv.lib.platforms; linux;
      license     = stdenv.lib.licenses.gpl2;
      maintainers = [ stdenv.lib.maintainers.mjanczyk ];
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
