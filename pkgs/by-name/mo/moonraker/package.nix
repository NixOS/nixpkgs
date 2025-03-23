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
  version = "0.9.3-unstable-2025-03-14";

  src = fetchFromGitHub {
    owner = "Arksine";
    repo = "moonraker";
    rev = "ebaa6645b2bcaa593d99e863530c52a84c69b470";
    sha256 = "sha256-4SefHXWT/P4F/RSpnLwAu34f8qs7lKW7O7NqOR2k9cE=";
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
