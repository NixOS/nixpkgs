{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  python3,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "allo";
  version = "1.0";

  __structuredAttrs = true;
  strictDeps = true;

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "joshpuckett";
    repo = "allo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tee0/qkKbD5S4pHHiuHv0sZAADy4xXdWKXM6O4lTATY=";
  };

  postPatch = ''
    rm -rf fonts
  '';

  nativeBuildInputs = [
    installFonts
    (python3.withPackages (
      ps: with ps; [
        afdko
        brotli
        cffsubr
        fonttools
        ufo2ft
        ufolib2
        zopfli
      ]
    ))
  ];

  buildPhase = ''
    runHook preBuild

    python3 build.py

    runHook postBuild
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Friendly sans-serif typeface optimized for screens and interfaces";
    homepage = "https://allo.joshpuckett.me";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ moraxyc ];
    platforms = lib.platforms.all;
  };
})
