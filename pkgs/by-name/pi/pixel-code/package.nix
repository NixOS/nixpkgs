{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  python3,
  woff2,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pixel-code";
  version = "2.2";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "qwerasd205";
    repo = "PixelCode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jpOj6MndjCTTPESIjh3VJW1FKK5n99W8GBgPqloaKFM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    (python3.withPackages (
      ps: with ps; [
        fontmake
        fonttools
        ufolib2
        pillow
      ]
    ))
    woff2
    installFonts
  ];

  postPatch = ''
        substituteInPlace src/build.sh \
          --replace-fail \
    '# Activate python virtual environment.
    ../activate.sh
    source ../.venv/bin/activate' ""
  '';

  buildPhase = ''
    runHook preBuild
    src/build.sh
    runHook postBuild
  '';

  meta = {
    homepage = "https://github.com/qwerasd205/PixelCode";
    description = "Pixel font designed to actually be good for programming";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ mattpolzin ];
  };
})
