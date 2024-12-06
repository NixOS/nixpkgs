{ lib, stdenvNoCC, fetchFromGitHub, python3, makeWrapper, unstableGitUpdater, nixosTests, useGpiod ? false }:

let
  pythonEnv = python3.withPackages (packages:
    with packages; [
      tornado
      pyserial-asyncio
      pillow
      lmdb
      streaming-form-data
      distro
      inotify-simple
      libnacl
      paho-mqtt
      pycurl
      zeroconf
      preprocess-cancellation
      jinja2
      dbus-next
      apprise
      python-periphery
      ldap3
    ]
  );
in stdenvNoCC.mkDerivation rec {
  pname = "moonraker";
  version = "0.8.0-unstable-2023-12-27";

  src = fetchFromGitHub {
    owner = "Arksine";
    repo = "moonraker";
    rev = "c226e9c1e44d65ff6ea400b81e3cedba7f637976";
    sha256 = "sha256-wdf4uab8pJEWaX6PFN9Y9pykmylmxJ4Oo5pwSQcyjCc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out $out/bin $out/lib
    cp -r moonraker $out/lib

    makeWrapper ${pythonEnv}/bin/python $out/bin/moonraker \
      --add-flags "$out/lib/moonraker/moonraker.py"
  '';

  passthru = {
    updateScript = unstableGitUpdater {
      url = meta.homepage;
      tagPrefix = "v";
    };
    tests.moonraker = nixosTests.moonraker;
  };

  meta = with lib; {
    description = "API web server for Klipper";
    homepage = "https://github.com/Arksine/moonraker";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zhaofengli ];
    mainProgram = "moonraker";
  };
}
