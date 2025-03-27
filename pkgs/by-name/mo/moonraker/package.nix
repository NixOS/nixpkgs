{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  makeWrapper,
  unstableGitUpdater,
  nixosTests,
  useGpiod ? false,
}:

let
  pythonEnv = python3.withPackages (
    packages: with packages; [
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
      dbus-fast
      apprise
      python-periphery
      ldap3
      importlib-metadata
    ]
  );
in
stdenvNoCC.mkDerivation rec {
  pname = "moonraker";
  version = "0.9.3-unstable-2025-03-26";

  src = fetchFromGitHub {
    owner = "Arksine";
    repo = "moonraker";
    rev = "b90c96524cd4aa5579ebc9899fd7812c1e756d86";
    sha256 = "sha256-oXdZdSoxfDNGR2n1L41zAG1aRzxeLTHtTmIUe2nWu/I=";
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
