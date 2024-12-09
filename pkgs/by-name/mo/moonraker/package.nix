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
      importlib-metadata
    ]
  );
in stdenvNoCC.mkDerivation rec {
  pname = "moonraker";
  version = "0.9.3-unstable-2024-11-17";

  src = fetchFromGitHub {
    owner = "Arksine";
    repo = "moonraker";
    rev = "ccfe32f2368a5ff6c2497478319909daeeeb8edf";
    sha256 = "sha256-aCYE3EmflMRIHnGnkZ/0+zScVA5liHSbavScQ7XRf/4=";
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
