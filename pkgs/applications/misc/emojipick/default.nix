{ stdenvNoCC
, fetchFromGitHub
, lib
, python3
, xclip
, libnotify
, dmenu
, rofi
, installShellFiles
# Boolean flags
, emojipick-use-rofi ? false
, emojipick-copy-to-clipboard ? true
, emojipick-show-notifications ? true
, emojipick-print-emoji ? true
, emojipick-font-family ? "Noto Color Emoji"
, emojipick-font-size ? "18"
}:

stdenvNoCC.mkDerivation {
  pname = "emojipick";
  version = "2021-01-27";

  src = fetchFromGitHub {
    owner = "thingsiplay";
    repo = "emojipick";
    rev = "20210127";
    sha256 = "1kib3cyx6z9v9qw6yrfx5sklanpk5jbxjc317wi7i7ljrg0vdazp";
  };

  dontConfigure = true;
  dontBuild = true;

  # Patch configuration
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

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    python3
    xclip
    libnotify
    (if emojipick-use-rofi then rofi else dmenu)
  ];

  strictDeps = true;

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
}
