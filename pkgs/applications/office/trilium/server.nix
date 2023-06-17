{ stdenv, lib, autoPatchelfHook, fetchurl, nixosTests
, metaCommon }:

let
  serverSource.url = "https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-server-${version}.tar.xz";
  serverSource.sha256 = "1ys9vnxrxhy52accqxkmvf63kqwaf3ba6ysk3a8wfn2rwxa766g8";
  version = "0.59.4";
in stdenv.mkDerivation rec {
  pname = "trilium-server";
  inherit version;
  meta = metaCommon // {
    platforms = [ "x86_64-linux" ];
  };

  src = fetchurl serverSource;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  patches = [
    # patch logger to use console instead of rolling files
    ./0001-Use-console-logger-instead-of-rolling-files.patch
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/share/trilium-server

    cp -r ./* $out/share/trilium-server
    runHook postInstall
  '';

  postFixup = ''
    cat > $out/bin/trilium-server <<EOF
    #!${stdenv.cc.shell}
    cd $out/share/trilium-server
    exec ./node/bin/node src/www
    EOF
    chmod a+x $out/bin/trilium-server
  '';

  passthru.tests = {
    trilium-server = nixosTests.trilium-server;
  };
}
