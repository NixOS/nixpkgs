{
  stdenv,
  fetchFromGitHub,
  lib,
  gcc,
  SDL2,
}:
stdenv.mkDerivation rec {
  pname = "objectsRotator";
  version = "0.1.40";

  src = fetchFromGitHub {
    owner = "KacperMachaj1";
    repo = "ObjectsRotator";
    rev = "a5b0ec2f66066cc6ed26df839020d6e55d54b1c8";
    hash = "sha256-Nq+EfRrbFd7uQ0Aq8CXKbmAYrm4PUMsvVUz8/2u8hhk=";
  };

  meta = with lib; {
    description = "Objects Rotator is a handy app designed to display and rotate 3D objects efficiently ";
    homepage = "https://github.com/KacperMachaj1/ObjectsRotator";
    license = licenses.eupl12;
    platforms = lib.platforms.all;
    maintainers = [maintainers.samemrecebi];
  };

  buildInputs = [
    gcc
    SDL2
  ];

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp objectsRotator $out/bin/
  '';
}
