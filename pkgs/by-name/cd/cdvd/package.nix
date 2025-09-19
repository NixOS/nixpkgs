{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "cdvd";
  version = "0-unstable-2026-09-19";

  src = fetchFromGitHub {
    owner = "Szmelc-INC";
    repo = "cdvd";
    rev = "5a6ff849a58e0923a86045bfd90067f8cb7f8d67";
    hash = "sha256-X3dRhW3/rvHOPD6SYT+7S3zLPC0GjYiru53gJUSq1BY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = [ ncurses ];

  installFlags = [ "BINDIR=$(out)/bin" ];

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

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
}
