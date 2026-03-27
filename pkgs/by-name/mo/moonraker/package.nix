{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  makeWrapper,
  nix-update-script,
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
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "Arksine";
    repo = "moonraker";
    tag = "v${version}";
    hash = "sha256-jprhbO3wQF/ozOf6VUrDYqNK0TstmLc4nZsZrB6hjOY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out $out/bin $out/lib
    cp -r moonraker $out/lib

    makeWrapper ${pythonEnv}/bin/python $out/bin/moonraker \
      --add-flags "$out/lib/moonraker/moonraker.py"
  '';

  passthru = {
    updateScript = nix-update-script { };
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
