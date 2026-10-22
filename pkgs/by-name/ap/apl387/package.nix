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
  version = "2026-08-17";

  src = fetchFromGitHub {
    owner = "dyalog";
    repo = "APL387";
    tag = finalAttrs.version;
    hash = "sha256-KeXZOX5ZSZjhrgN54w2yHpiOhTnk9NU3F8jh/AR1l44=";
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
