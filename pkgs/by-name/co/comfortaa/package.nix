{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "comfortaa";
  version = "unstable-2021-07-29";

  outputs = [
    "out"
    "webfont"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "comfortaa";
    rev = "2a87ac6f6ea3495150bfa00d0c0fb53dd0a2f11b";
    hash = "sha256-O5+omTQIsc7lfNLonYC2qeRbLxrWYES0u9dGACNj54A=";
  };

  dontBuild = true;
  nativeBuildInputs = [ installFonts ];

  preInstall = ''
    rm -r old/
  '';
  postInstall = ''
    install -D FONTLOG.txt README.md -t $doc/share/doc/${finalAttrs.pname}-${finalAttrs.version}
  '';

  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  meta = {
    homepage = "http://aajohan.deviantart.com/art/Comfortaa-font-105395949";
    description = "Clean and modern font suitable for headings and logos";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.rycee ];
  };
})
