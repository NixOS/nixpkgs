{
  fetchFromGitHub,
  hunspell,
  hunspellDicts,
  less,
  lib,
  nix-update-script,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hunspell-colorize";
  version = "0-unstable-2026-01-19";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "torvalds";
    repo = "HunspellColorize";
    rev = "87c358bfc99454490f1ef3afcb9ecf7590a9367e";
    hash = "sha256-Tqb9b/1k8AhaaqHVB/4Jrs4os9hilJ2Rgt71tukuPp4=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ hunspell ];

  postPatch = ''
    substituteInPlace Makefile --replace-fail pkg-config '$(PKG_CONFIG)'
    substituteInPlace huncolor.c \
      --replace-fail /usr/share/hunspell ${hunspellDicts.en_US}/share/hunspell \
      --replace-fail '"less"' '"${lib.getExe less}"'
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    runHook preInstall

    install -D huncolor "$out"/bin/${finalAttrs.meta.mainProgram}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Wrapper around less that highlights misspelled words using Hunspell";
    homepage = "https://github.com/torvalds/HunspellColorize";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "huncolor";
    platforms = lib.platforms.unix;
  };
})
