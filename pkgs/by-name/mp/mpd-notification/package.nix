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
<<<<<<< HEAD
  version = "0.9.3";
=======
  version = "0.9.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "eworm-de";
    repo = "mpd-notification";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-1xTIqJtTz7vfg34JvlwNe6kNZuPfd3KnAT0rI8ZYk2U=";
=======
    hash = "sha256-2rnZkVKrk8jgZz/EcZGQ34tLZrVttjq3tq8k2xSl00A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Notifications for mpd";
    homepage = "https://github.com/eworm-de/mpd-notification";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      CaitlinDavitt
      matthiasbeyer
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Notifications for mpd";
    homepage = "https://github.com/eworm-de/mpd-notification";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      CaitlinDavitt
      matthiasbeyer
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "mpd-notification";
  };
}
