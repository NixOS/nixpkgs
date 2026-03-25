{
  fetchFromGitHub,
  hunspell,
  hunspellDicts,
  less,
  lib,
  makeBinaryWrapper,
  nix-update-script,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hunspell-colorize";
  version = "0-unstable-2026-01-19";

  src = fetchFromGitHub {
    owner = "torvalds";
    repo = "HunspellColorize";
    rev = "87c358bfc99454490f1ef3afcb9ecf7590a9367e";
    hash = "sha256-Tqb9b/1k8AhaaqHVB/4Jrs4os9hilJ2Rgt71tukuPp4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    hunspell
    hunspellDicts.en_US
  ];

  postPatch = ''
    substituteInPlace Makefile --replace-fail gcc cc
    substituteInPlace huncolor.c \
      --replace-fail /usr/share/hunspell ${hunspellDicts.en_US}/share/hunspell
  '';

  installPhase = ''
    runHook preInstall

    install -D huncolor "$out"/bin/${finalAttrs.meta.mainProgram}
    wrapProgram "$_" --prefix PATH : ${lib.makeBinPath [ less ]}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wrapper around 'less' to colorize spelling mistakes using Hunspell";
    homepage = "https://github.com/torvalds/HunspellColorize";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "huncolor";
    platforms = lib.platforms.all;
  };
})
