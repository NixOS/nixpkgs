{ stdenv, buildEnv, fetchFromGitHub, mono }:

let
  version = "1.8.4.1";
  drv = stdenv.mkDerivation {
    name = "keepasshttp-${version}";
    src = fetchFromGitHub {
      owner = "pfn";
      repo = "keepasshttp";
      rev = "${version}";
      sha256 = "1074yv0pmzdwfwkx9fh7n2igdqwsyxypv55khkyng6synbv2p2fd";
    };

    meta = {
      description = "KeePass plugin to expose password entries securely (256bit AES/CBC) over HTTP";
      homepage    = https://github.com/pfn/keepasshttp;
      platforms   = with stdenv.lib.platforms; linux;
      license     = stdenv.lib.licenses.gpl3;
    };

    pluginFilename = "KeePassHttp.plgx";

    installPhase = ''
      mkdir -p $out/lib/dotnet/keepass/
      cp $pluginFilename $out/lib/dotnet/keepass/$pluginFilename
    '';
  };
in
  # Mono is required to compile plugin at runtime, after loading.
  buildEnv { name = drv.name; paths = [ mono drv ]; }
