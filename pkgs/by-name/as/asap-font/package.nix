{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "asap-font";
  version = "3.0-unstable-2026-03-21";

  strictDeps = true;
  __structuredAttrs = true;

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "Omnibus-Type";
    repo = "Asap";
    rev = "ca471c0ccf90a5c66155d4bcaa020859804ffd00";
    hash = "sha256-Z1c2G6Q5hmn+neF6fE0N5pgszha5pfmXFtP5HkhO4uQ=";
  };

  postPatch = ''
    rm -r old-files
  '';

  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [ installFonts ];

  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/Omnibus-Type/Asap";
    description = "Contemporary sans-serif family with subtle rounded corners";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ozozka ];
  };
}
