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
  version = "Linux";

  src = fetchFromGitHub {
    owner = "Szmelc-INC";
    repo = "cdvd";
    tag = finalAttrs.version;
    hash = "sha256-V+qajFPBWBYA/L5c3OixGNLmOJVmPXrsIKhEeNUdcaw=";
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
