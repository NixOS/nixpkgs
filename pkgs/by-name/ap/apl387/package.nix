{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  python3,
  fontforge,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "apl387";
  version = "0-unstable-2025-12-13";

  src = fetchFromGitHub {
    owner = "dyalog";
    repo = "APL387";
    rev = "60ff47a728ee043f878dc2ed801d53e29fcebe9d";
    hash = "sha256-VyO+7PUYcmmhbFVAW37yvWQLUpt0K/ihA/JGmbt+4Uk=";
  };

  nativeBuildInputs = [
    python3
    fontforge
    installFonts
  ];

  buildPhase = ''
    runHook preBuild
    ${python3.executable} script.py . "${finalAttrs.src.rev}"
    runHook postBuild
  '';

  outputs = [
    "out"
    "webfont"
  ];

  postInstall = ''
    installFont svg $out/share/fonts/svg
  '';

  meta = {
    homepage = "https://dyalog.github.io/APL387";
    description = "Redrawn and extended version of Adrian Smith's classic APL385 font with clean rounded look";
    license = lib.licenses.unlicense;
    maintainers = [
      lib.maintainers.sternenseemann
      lib.maintainers.sigmanificient
    ];
    platforms = lib.platforms.all;
  };
})
