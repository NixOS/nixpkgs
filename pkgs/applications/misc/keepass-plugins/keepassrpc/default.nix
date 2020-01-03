{ stdenv, buildEnv, fetchurl, mono }:

let
  version = "1.8.0";
  drv = stdenv.mkDerivation {
    pname = "keepassrpc";
    inherit version;
    src = fetchurl {
      url    = "https://github.com/kee-org/keepassrpc/releases/download/v${version}/KeePassRPC.plgx";
      sha256 = "1dclfpia559cqf78qw29zz235h1df5md4kgjv3bbi8y41wwmx7cd";
    };

    meta = with stdenv.lib; {
      description = "The KeePassRPC plugin that needs to be installed inside KeePass in order for Kee to be able to connect your browser to your passwords";
      homepage    = https://github.com/kee-org/keepassrpc;
      platforms   = [ "x86_64-linux" ];
      license     = licenses.gpl2;
      maintainers = with maintainers; [ mjanczyk svsdep mgregoire ];
    };

    pluginFilename = "KeePassRPC.plgx";

    unpackCmd = ''
      mkdir deps/
      cp -p $src deps/$pluginFilename
    '';
    sourceRoot = "deps";

    installPhase = ''
      mkdir -p $out/lib/dotnet/keepass/
      cp $pluginFilename $out/lib/dotnet/keepass/$pluginFilename
    '';
  };
in
  # Mono is required to compile plugin at runtime, after loading.
  buildEnv { name = drv.name; paths = [ mono drv ]; }
