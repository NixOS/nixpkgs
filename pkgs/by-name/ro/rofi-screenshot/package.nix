{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, libnotify
, slop
, ffcast
, ffmpeg
, xclip
, rofi
, coreutils
, gnused
, procps
}:

stdenv.mkDerivation rec {
  pname = "rofi-screenshot";
  version = "2023-07-02";

  src = fetchFromGitHub {
    owner = "ceuk";
    repo = pname;
    rev = "365cfa51c6c7deb072d98d7bfd68cf4038bf2737";
    hash = "sha256-M1cab+2pOjZ2dElMg0Y0ZrIxRE0VwymVwcElgzFrmVs=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/${pname} \
      --set PATH ${
        lib.makeBinPath [
          libnotify
          slop
          ffcast
          ffmpeg
          xclip
          rofi
          coreutils
          gnused
          procps
        ]
      }
  '';

  installPhase = ''
    install -Dm755 ${pname} $out/bin/${pname}
  '';

  meta = {
    description =
      "Use rofi to perform various types of screenshots and screen captures";
    mainProgram = "rofi-screenshot";
    homepage = "https://github.com/ceuk/rofi-screenshot";
    maintainers = with lib.maintainers; [ zopieux ];
    platforms = lib.platforms.all;
    license = lib.licenses.wtfpl;
  };
}
