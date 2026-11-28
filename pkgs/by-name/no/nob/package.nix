{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nob";
  version = "3.10.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "nob.h";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zWSlvnB/Iavkmd+JJHTmcFGNJkeFesNLb1T7OCW2IbU=";
  };

  setupHook = ./setup-hook.sh;

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 nob.h $out/include/nob.h
    runHook postInstall
  '';

  meta = {
    description = "Header-only C library for writing build systems in C";
    homepage = "https://github.com/tsoding/nob.h";
    changelog = "https://github.com/tsoding/nob.h/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      unlicense
    ];
    maintainers = with lib.maintainers; [ evanwporter ];
    platforms = lib.platforms.all;
  };
})
