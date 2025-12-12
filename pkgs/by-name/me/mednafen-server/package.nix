{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mednafen-server";
  version = "0.5.2";

  src = fetchurl {
    url = "https://mednafen.github.io/releases/files/mednafen-server-${finalAttrs.version}.tar.xz";
    hash = "sha256-uJmxaMW+bydfAXq8XDOioMoBOLUsi5OT2Tpbbotsp3Y=";
  };

  strictDeps = true;

  postInstall = ''
    install -m 644 -Dt $out/share/mednafen-server standard.conf
  '';

  meta = {
    description = "Netplay server for Mednafen";
    mainProgram = "mednafen-server";
    homepage = "https://mednafen.github.io/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
