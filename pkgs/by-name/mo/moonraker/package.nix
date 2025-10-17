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
  version = "0.9.3-unstable-2025-10-12";

  src = fetchFromGitHub {
    owner = "Arksine";
    repo = "moonraker";
    rev = "3eb575d0ec4408954bfa835a36ddf2cce2047bd4";
    sha256 = "sha256-koZxNKH6Mb1j9uw7k/ZxmGSGejMush3QdJeUKK2nFqg=";
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
