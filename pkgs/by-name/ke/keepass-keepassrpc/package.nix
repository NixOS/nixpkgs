{
  lib,
  stdenv,
  buildEnv,
  fetchurl,
  mono,
}:

let
  version = "1.16.0";
  drv = stdenv.mkDerivation {
    pname = "keepassrpc";
    inherit version;
    src = fetchurl {
      url = "https://github.com/kee-org/keepassrpc/releases/download/v${version}/KeePassRPC.plgx";
      hash = "sha256-p5dYluCrXAKhBhlm6sQ3QQE3gLMJzEZsHXwGnVeXFos=";
    };

    meta = with lib; {
      description = "KeePassRPC plugin that needs to be installed inside KeePass in order for Kee to be able to connect your browser to your passwords";
      homepage = "https://github.com/kee-org/keepassrpc";
      platforms = [ "x86_64-linux" ];
      license = licenses.gpl2;
      maintainers = with maintainers; [
        mjanczyk
        svsdep
        mgregoire
      ];
    };

    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/lib/dotnet/keepass/
      cp $src $out/lib/dotnet/keepass/
    '';
  };
in
# Mono is required to compile plugin at runtime, after loading.
buildEnv {
  name = drv.name;
  paths = [
    mono
    drv
  ];
}
