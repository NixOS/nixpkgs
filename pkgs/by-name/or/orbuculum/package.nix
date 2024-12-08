{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, czmq
, libusb1
, ncurses
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "orbuculum";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "orbcode";
    repo = pname;
    rev = "V${version}";
    sha256 = "sha256-Ohcc8739W/EmDjOYhcMgzEPVhzbWrUYgsPLdy4qzxhY=";
  };

  prePatch = ''
    substituteInPlace meson.build --replace \
      "/etc/udev/rules.d" "$out/etc/udev/rules.d"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    czmq
    libusb1
    ncurses
    SDL2
  ];

  installFlags = [
    "INSTALL_ROOT=$(out)/"
  ];

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d/
    cp $src/Support/60-orbcode.rules $out/etc/udev/rules.d/
  '';

  meta = with lib; {
    description = "Cortex M SWO SWV Demux and Postprocess for the ORBTrace";
    homepage = "https://orbcode.org";
    changelog = "https://github.com/orbcode/orbuculum/blob/V${version}/CHANGES.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ newam ];
    platforms = platforms.linux;
  };
}
