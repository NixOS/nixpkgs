{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "manuale";
  version = "1.001-unstable-2021-08-18";

  strictDeps = true;
  __structuredAttrs = true;

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "Omnibus-Type";
    repo = "Manuale";
    rev = "20a5ab6a0da1c8cb56916d843e50db0ad6b6dfd3";
    hash = "sha256-se4sySh0iQZN7Mek18ZmwSUIFcRWHTT/In3A9SJ9pfE=";
  };

  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [ installFonts ];

  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/Omnibus-Type/Manuale/";
    description = "Serif typeface designed for print and online books, newspapers and magazines";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ozozka ];
  };
}
