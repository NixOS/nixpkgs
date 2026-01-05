{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  wrapGAppsHook3,
  cairo,
  e2fsprogs,
  gmp,
  gtk3,
  libGL,
  libX11,
  libgcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "banana-accounting";
  version = "10.1.24";

  srcs = fetchurl {
    url = "https://web.archive.org/web/20250416013207/https://www.banana.ch/accounting/files/bananaplus/exe/bananaplus.tgz";
    hash = "sha256-5GewPGOCyeS6faL8aMUZ/JDUUn2PGuur0ws/7nlNX6M=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
  ];

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

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt $out/bin $out/share
    cp -r . $out/opt/banana-accounting
    ln -s $out/opt/banana-accounting/usr/bin/bananaplus $out/bin/bananaplus
    ln -s $out/opt/banana-accounting/usr/share/applications $out/share/applications
    ln -s $out/opt/banana-accounting/usr/share/icons $out/share/icons

    runHook postInstall
  '';

  meta = {
    description = "Accounting Software for small companies, associations and individuals";
    homepage = "https://www.banana.ch";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ jacg ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
