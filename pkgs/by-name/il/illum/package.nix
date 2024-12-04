{ lib, stdenv, fetchFromGitHub, fetchpatch, pkg-config, ninja, libevdev, libev, udev }:

stdenv.mkDerivation rec {
  pname = "illum";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "jmesmon";
    repo = "illum";
    rev = "v${version}";
    sha256 = "S4lUBeRnZlRUpIxFdN/bh979xvdS7roF6/6Dk0ZUrnM=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      name = "prevent-unplug-segfault"; # See https://github.com/jmesmon/illum/issues/19
      url = "https://github.com/jmesmon/illum/commit/47b7cd60ee892379e5d854f79db343a54ae5a3cc.patch";
      sha256 = "sha256-hIBBCIJXAt8wnZuyKye1RiEfOCelP3+4kcGrM43vFOE=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ninja libevdev libev udev ];

  configurePhase = ''
    bash ./configure
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv illum-d $out/bin
  '';

  meta = {
    homepage = "https://github.com/jmesmon/illum";
    description = "Daemon that wires button presses to screen backlight level";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.dancek ];
    license = lib.licenses.agpl3Plus;
    mainProgram = "illum-d";
  };
}
