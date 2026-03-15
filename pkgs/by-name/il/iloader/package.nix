{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  glib,
  gtk3,
  wrapGAppsHook3,
  webkitgtk_4_1,
  gdk-pixbuf,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "iloader";
  version = "2.0.5";

  src = fetchurl {
    url = "https://github.com/nab138/iloader/releases/download/v${finalAttrs.version}/iloader-linux-amd64.deb";
    hash = "sha256-GXA3PcgBgaYmqaQJuC2oc3esA0zvltxcgVDJFsnymrQ=";
  };

  unpackCmd = "dpkg -x $curSrc source";

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    webkitgtk_4_1
    gdk-pixbuf
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv usr/share usr/bin $out

    runHook postInstall
  '';

  meta = {
    description = "User friendly sideloader";
    homepage = "https://github.com/nab138/iloader";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ern775 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "iloader";
  };
})
