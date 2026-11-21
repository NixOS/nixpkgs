{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "3270font";
  version = "3.0.1";

  # Added outputs to handle the web fonts
  outputs = [
    "out"
    "webfont"
  ];

  src = fetchzip {
    url = "https://github.com/rbanffy/3270font/releases/download/v${finalAttrs.version}/3270_fonts_d916271.zip";
    hash = "sha256-Zi6Lp5+sqfjIaHmnaaemaw3i+hXq9mqIsK/81lTkwfM=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    installFonts
  ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  meta = {
    description = "Monospaced font based on IBM 3270 terminals";
    homepage = "https://github.com/rbanffy/3270font";
    changelog = "https://github.com/rbanffy/3270font/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = [
      lib.licenses.bsd3
      lib.licenses.ofl
    ];
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
