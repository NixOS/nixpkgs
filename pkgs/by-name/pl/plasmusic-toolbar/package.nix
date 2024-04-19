{ lib, stdenv, fetchFromGitHub, kdePackages }:

stdenv.mkDerivation rec {
  pname = "plasmusic-toolbar";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "ccatterina";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BSVVEtodPKvtX7HGpgxAIq03BHhj5NmLZGDMqMQLjR8=";
  };

  dontBuild = true;
  nativeBuildInputs = [ kdePackages.kpackage ];

  installPhase = ''
    runHook preInstall

    kpackagetool6 -i src -p $out/share/plasma/plasmoids/

    runHook postInstall
  '';

  meta = with lib; {
    description = "KDE Plasma widget that shows currently playing song information and provide playback controls";
    homepage = "https://github.com/ccatterina/plasmusic-toolbar";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ccatterina ];
    platforms = platforms.linux;
  };
}
