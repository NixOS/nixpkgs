{
  lib,
  stdenv,
  pkg-config,
  fetchFromGitHub,
  file,
  iniparser,
  ffmpeg,
  libnotify,
  libmpdclient,
  discount,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "mpd-notification";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "eworm-de";
    repo = "mpd-notification";
    rev = version;
    hash = "sha256-1xTIqJtTz7vfg34JvlwNe6kNZuPfd3KnAT0rI8ZYk2U=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    iniparser
    libnotify
    file
    ffmpeg
    libmpdclient
    discount
    systemd
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv mpd-notification $out/bin

    mkdir -p $out/lib/systemd/user
    cp systemd/mpd-notification.service $out/lib/systemd/user

    runHook postInstall
  '';

  postPatch = ''
    substituteInPlace systemd/mpd-notification.service --replace /usr $out
  '';

  meta = with lib; {
    description = "Notifications for mpd";
    homepage = "https://github.com/eworm-de/mpd-notification";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ CaitlinDavitt ];
    platforms = platforms.unix;
    mainProgram = "mpd-notification";
  };
}
