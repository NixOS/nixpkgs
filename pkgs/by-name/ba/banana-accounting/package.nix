{
  autoPatchelfHook,
  cairo,
  e2fsprogs,
  fetchurl,
  gmp,
  gtk3,
  libGL,
  libX11,
  lib,
  stdenv,
  libgcrypt,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "banana-accounting";
  version = "10.0.12";

  srcs = fetchurl {
    url = "https://web.archive.org/web/20220821013214/https://www.banana.ch/accounting/files/bananaplus/exe/bananaplus.tgz";
    hash = "sha256-Xs7K/Z6qM1fKKfYMkwAGznNR0Kt/gY7qTr8ZOriIdYw=";
  };

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [
    cairo
    e2fsprogs
    gmp
    gtk3
    (lib.getLib stdenv.cc.cc)
    libGL
    libX11
    libgcrypt
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv ./* $out
    ln -s $out/usr/bin/bananaplus $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Accounting Software for small companies, associations and individuals";
    homepage = "https://www.banana.ch/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jacg ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
