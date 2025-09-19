{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  tinyxxd,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdvd";
  version = "0-unstable-2025-09-09";

  src = fetchFromGitHub {
    owner = "Szmelc-INC";
    repo = "cdvd";
    rev = "5ec143b0c8847bab03e48751eebaa55b87e2faa9";
    hash = "sha256-Vy38DrMwQ/H7/ZSYbHq06Ua+6hIUpYXz/HFbb5aK/T0=";
  };

  strictDeps = true;

  buildInputs = [ ncurses ];

  nativeBuildInputs = [ tinyxxd ];

  installPhase = ''
    runHook preInstall

    install -D dvd $out/bin/${finalAttrs.meta.mainProgram}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Eyecandy screensaver";
    longDescription = ''
      𝙰 𝚝𝚒𝚗𝚢 𝙲 / 𝚗𝚌𝚞𝚛𝚜𝚎𝚜 𝚎𝚢𝚎𝚌𝚊𝚗𝚍𝚢 for command line, 𝚍𝚛𝚊𝚠𝚜 𝚊 𝚋𝚘𝚞𝚗𝚌𝚒𝚗𝚐
      𝙳𝚟𝙳 𝚕𝚘𝚐𝚘 𝚠𝚒𝚝𝚑 𝚊 𝚏𝚎𝚠 𝚎𝚡𝚝𝚛𝚊 𝚏𝚎𝚊𝚝𝚞𝚛𝚎𝚜.
    '';
    homepage = "https://github.com/Szmelc-INC/cdvd";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "cdvd";
    platforms = lib.platforms.all;
  };
})
