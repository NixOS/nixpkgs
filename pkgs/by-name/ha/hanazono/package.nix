{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "hanazono";
  version = "20170904";

  src = fetchzip {
    url = "mirror://osdn/hanazono-font/68253/hanazono-${version}.zip";
    stripRoot = false;
    hash = "sha256-qd0q4wQnHBGLT7C+UQIiOHnxCnRCscMZcj3P5RRxD1U=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype
    install -Dm644 *.txt -t $out/share/doc/hanazono

    runHook postInstall
  '';

  meta = with lib; {
    description = "Japanese Mincho-typeface TrueType font";
    homepage = "https://fonts.jp/hanazono/";
    longDescription = ''
      Hanazono Mincho typeface is a Japanese TrueType font that developed with a
      support of Grant-in-Aid for Publication of Scientific Research Results
      from Japan Society for the Promotion of Science and the International
      Research Institute for Zen Buddhism (IRIZ), Hanazono University. also with
      volunteers who work together on glyphwiki.org.
    '';

    # Dual-licensed under OFL and the following:
    # This font is a free software.
    # Unlimited permission is granted to use, copy, and distribute it, with
    # or without modification, either commercially and noncommercially.
    # THIS FONT IS PROVIDED "AS IS" WITHOUT WARRANTY.
    license = [
      licenses.ofl
      licenses.free
    ];
    maintainers = with maintainers; [ mathnerd314 ];
    platforms = platforms.all;
  };
}
