{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  installFonts,
  python3,
  ttfautohint,
  fontforge,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "libron";
  version = "0.30";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nicoverbruggen";
    repo = "libron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uLtGyKUyVv6f5VryqX/DXR0IAgeEe/LNVCBcckcIFCc=";
  };

  nativeBuildInputs = [
    installFonts
    (python3.withPackages (
      python-packages: with python-packages; [
        fonttools
        brotli
      ]
    ))
    ttfautohint
    fontforge
  ];

  buildPhase = ''
    python3 ./build.py
  '';

  dontInstallFonts = 1;

  installPhase = ''
    runHook preInstall
    installFont ttf $out/share/fonts/truetype/libron
    installFont woff2 $webfont/share/fonts/woff2/libron
    runHook postInstall
  '';

  outputs = [
    "out"
    "webfont"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The Libron font is a modified version of Readerly with various edits to give it a more neutral look.";
    homepage = "https://github.com/nicoverbruggen/libron";
    changelog = "https://github.com/nicoverbruggen/libron/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ undefprophet ];
    platforms = lib.platforms.all;
  };
})
