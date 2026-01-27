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
  version = "0.10.0-unstable-2026-01-22";

  src = fetchFromGitHub {
    owner = "Arksine";
    repo = "moonraker";
    rev = "3e29720cb2ac8c5679c2085849f344f33f089be4";
    sha256 = "sha256-fzdqozm48wBMGwGLH5KaIuEVDI1YHPNJdK5u0Ec+y2c=";
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

  meta = {
    description = "API web server for Klipper";
    homepage = "https://github.com/Arksine/moonraker";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ zhaofengli ];
    mainProgram = "moonraker";
  };
}
