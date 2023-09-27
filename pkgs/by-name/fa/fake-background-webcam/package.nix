{ lib
, stdenvNoCC
, fetchFromGitHub
, python310
}:

stdenvNoCC.mkDerivation {
  pname = "fake-background-webcam";
  version = "0-unstable-2023-05-15";

  src = fetchFromGitHub {
    owner = "fangfufu";
    repo = "Linux-Fake-Background-Webcam";
    rev = "6aa175443a6498bfd977e6472a1696911ba821fb";
    hash = "sha256-EhhrmBoGvmqZ5uBDLCTs3rDwOVKMGq/sxJCH7JVmP+0=";
  };

  buildInputs = [
    (python310.withPackages (ps: with ps; [
      numpy
      requests
      requests-unixsocket
      aiohttp
      inotify-simple
      pyfakewebcam
      configargparse
      cmapy
      mediapipe-bin
    ]))
  ];

  postPatch = ''
    export images="$out/share/$pname"
    substituteInPlace fake.py \
      --replace-fail '"foreground.jpg"' "'$images/foreground.jpg'" \
      --replace-fail '"background.jpg"' "'$images/background.jpg'"
  '';

  installPhase = ''
    install -Dm0777 fake.py $out/bin/$pname
    install -Dt $images foreground.jpg background.jpg
    install -Dt $out/share/systemd/user systemd-user/fakecam.service
  '';

  meta = with lib;{
    homepage = "https://github.com/fangfufu/Linux-Fake-Background-Webcam";
    license = licenses.gpl3Only;
    description = "Virtual background-replacing camera";
    mantainers = with mantainers;[ pasqui023 ];
  };
}
