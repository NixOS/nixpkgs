{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation {
  pname = "serenityos-emoji-font";
  version = "1.0";
  src = fetchurl {
    url = "https://linusg.github.io/serenityos-emoji-font/SerenityOS-Emoji.ttf";
    hash = "sha256-V4lBNZNyr9hS/kMIWkSuLv+Av7xH9jXBjRofVOYeQ6I=";
    downloadToTemp = true;
    recursiveHash = true;
    postFetch = ''
      install -D $downloadedFile $out/SerenityOS-Emoji.ttf
    '';
  };
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -r $src $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "😃 The SerenityOS pixel art emojis as a TTF";
    homepage = "https://emoji.serenityos.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      voidnoi
    ];
  };
}
