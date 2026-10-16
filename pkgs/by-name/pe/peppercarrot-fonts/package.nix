{
  lib,
  fetchFromGitLab,
  fontforge,
  stdenvNoCC,
  installFonts,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "peppercarrot-fonts";
  version = "1.0.0";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "peppercarrot";
    repo = "fonts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tabiNRJZRwSYGV3DtXhg0C78E7TlDQYcpa/5bJrkhfs=";
  };

  # Other folders include third-party fonts for other alphabets
  sourceRoot = "${finalAttrs.src.name}/Latin";

  postPatch = ''
    # Some fonts are duplicated with symlinks
    find . -type l -delete

    # Already in pkgs.yanone-kaffeesatz
    rm YanoneKaffeesatz*
  '';

  nativeBuildInputs = [
    fontforge
    installFonts
  ];

  # Those are only built as woff2
  buildPhase = ''
    runHook preBuild
    fontforge -lang=ff -c 'Open("sources/Handserah.sfd"); Generate("Handserah.otf")'
    fontforge -lang=ff -c 'Open("sources/PepperCarrot.sfd"); Generate("PepperCarrot.otf")'
    runHook postBuild
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Open fonts used in the webcomic Pepper&Carrot";
    homepage = "https://www.peppercarrot.com/en/fonts";
    changelog = "https://framagit.org/peppercarrot/fonts/-/blob/master/CHANGELOG.md";
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.nim65s ];
    license =
      with lib.licenses;
      AND [
        asl20
        cc-by-30
        (WITH gpl2 fontException)
        (WITH gpl3 fontException)
        gpl3
        mplus
        ofl
        ofl10
      ];
  };
})
