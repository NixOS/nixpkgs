{
  lib,
  dmenu,
  fetchFromGitHub,
  installShellFiles,
  libnotify,
  python3,
  rofi,
  stdenvNoCC,
  xclip,
  # Boolean flags
  emojipick-copy-to-clipboard ? true,
  emojipick-print-emoji ? true,
  emojipick-show-notifications ? true,
  emojipick-use-rofi ? false,
  # Configurable options
  emojipick-font-family ? "Noto Color Emoji",
  emojipick-font-size ? "18",

}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "emojipick";
  version = "20210127";

  src = fetchFromGitHub {
    owner = "thingsiplay";
    repo = "emojipick";
    rev = finalAttrs.version;
    hash = "sha256-96u2wcuSnngiP2Ew2Zcs81pFpy7dZW84Tjt90z0bK84=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    libnotify
    python3
    xclip
    (if emojipick-use-rofi then rofi else dmenu)
  ];

  dontConfigure = true;

  dontBuild = true;

  strictDeps = true;

  # notify-send has to be patched in a bash file
  postPatch = ''
    substituteInPlace emojipick \
      --replace "use_rofi=0" "use_rofi=${builtins.toString (lib.boolToInt emojipick-use-rofi)}" \
      --replace "copy_to_clipboard=1" "copy_to_clipboard=${builtins.toString (lib.boolToInt emojipick-copy-to-clipboard)}" \
      --replace "show_notification=1" "show_notification=${builtins.toString (lib.boolToInt emojipick-show-notifications)}" \
      --replace "print_emoji=1" "print_emoji=${builtins.toString (lib.boolToInt emojipick-print-emoji)}" \
      --replace "font_family='\"Noto Color Emoji\"'" "font_family='\"${emojipick-font-family}\"'" \
      --replace 'font_size="18"' 'font_size="${emojipick-font-size}"' \
      ${lib.optionalString emojipick-use-rofi "--replace 'rofi ' '${rofi}/bin/rofi '"} \
      --replace notify-send ${libnotify}/bin/notify-send
  '';

  installPhase = ''
    runHook preInstall

    installBin emojipick emojiget.py

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/thingsiplay/emojipick";
    description = "Get a selection of emojis with dmenu or rofi";
    license = lib.licenses.mit;
    mainProgram = "emojipick";
    maintainers = with lib.maintainers; [ alexnortung ];
    platforms = lib.platforms.linux;
  };
})
