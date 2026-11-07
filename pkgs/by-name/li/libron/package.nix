{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  installFonts,
  python3,
  ttfautohint,
  fontforge,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libron";
  version = "0.25";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "nicoverbruggen";
    repo = "libron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lvPlEWz/D6Ldmo29xp9e1eQIyHaLXa5c7Y+aP5e3F6Q=";
  };

  nativeBuildInputs = [
    installFonts
    ttfautohint
    fontforge
    (python3.withPackages (
      ps: with ps; [
        fonttools
        brotli
      ]
    ))
  ];

  passthru.updateScript = nix-update-script { };

  buildPhase = ''
    python3 ./build.py
  '';

  outputs = [
    "out"
    "webfont"
  ];

  meta = {
    description = "A manually tuned font revision of Readerly, with reduced and altered serifs, optimized for digital reading and e-readers. OFL licensed";
    homepage = "https://github.com/nicoverbruggen/libron";
    changelog = "https://github.com/nicoverbruggen/libron/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ iogamaster ];
    mainProgram = "libron";
    platforms = lib.platforms.all;
  };
})
