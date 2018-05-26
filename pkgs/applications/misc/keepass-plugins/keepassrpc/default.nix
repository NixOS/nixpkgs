{ stdenv, buildEnv, fetchurl, mono }:

let
  version = "1.7.3.1";
  drv = stdenv.mkDerivation {
    name = "keepassrpc-${version}";
    src = fetchurl {
      url    = "https://github.com/kee-org/keepassrpc/releases/download/v${version}/KeePassRPC.plgx";
      sha256 = "1y9b35qg27caj3pbaqqzrqpk61hbbd8617ziwdc9vl799i786m9k";
    };

    meta = with stdenv.lib; {
      description = "The KeePassRPC plugin that needs to be installed inside KeePass in order for Kee to be able to connect your browser to your passwords";
      homepage    = https://github.com/kee-org/keepassrpc;
      platforms   = [ "x86_64-linux" ];
      license     = licenses.gpl2;
      maintainers = with maintainers; [ mjanczyk svsdep ];
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
