{
  buildFHSEnv,
  callPackage,
  lib,
}:
let

  shticker-book-unwritten-unwrapped = callPackage ./unwrapped.nix { };

in
buildFHSEnv {
  pname = "shticker_book_unwritten";
  inherit (shticker-book-unwritten-unwrapped) version;
  targetPkgs =
    pkgs: with pkgs; [
      alsa-lib
      libglvnd
      libpulseaudio
      shticker-book-unwritten-unwrapped
      libx11
      libxcursor
      libxext
    ];
  runScript = "shticker_book_unwritten";

  meta = {
    description = "Minimal CLI launcher for the Toontown Rewritten MMORPG";
    mainProgram = "shticker_book_unwritten";
    homepage = "https://github.com/JonathanHelianthicusDoe/shticker_book_unwritten";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.reedrw ];
    platforms = lib.platforms.linux;
  };
}
