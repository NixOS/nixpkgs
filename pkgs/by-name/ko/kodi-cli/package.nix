{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  curl,
  bash,
  jq,
  youtube-dl,
  zenity,
}:

stdenv.mkDerivation rec {
  pname = "kodi-cli";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "nawar";
    repo = "kodi-cli";
    rev = version;
    hash = "sha256-VXHnhQSqOt5G3my6DnPbs+db41jTyYXHvBSi5wRuPDk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a kodi-cli $out/bin
    wrapProgram $out/bin/kodi-cli --prefix PATH : ${
      lib.makeBinPath [
        curl
        bash
      ]
    }
    cp -a playlist_to_kodi $out/bin
    wrapProgram $out/bin/playlist_to_kodi --prefix PATH : ${
      lib.makeBinPath [
        curl
        bash
        zenity
        jq
        youtube-dl
      ]
    }
  '';

  meta = {
    homepage = "https://github.com/nawar/kodi-cli";
    description = "Kodi/XBMC bash script to send Kodi commands using JSON RPC. It also allows sending YouTube videos to Kodi";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.pstn ];
  };
}
