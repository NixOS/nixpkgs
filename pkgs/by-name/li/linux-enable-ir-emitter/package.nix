{ stdenv
, lib
, makeWrapper
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gtk3
, python3
, opencv
, usbutils
}:
stdenv.mkDerivation rec {
  pname = "linux-enable-ir-emitter";
  version = "5.2.4";

  src = fetchFromGitHub {
    owner = "EmixamPP";
    repo = pname;
    rev = version;
    hash = "sha256-PJSoSxR9B6EIwOH3B1h6Z+KQAYCXBoubOCMAeMAQ828=";
  };

  patches = [
    # prevent meson from creating subdir in /var
    ./install.patch
  ];

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gtk3
    python3
    usbutils
    (opencv.override { enableGtk3 = true; })
  ];

  mesonFlags = [
    "-Dsysconfdir=/var/lib"
  ];

  postInstall = ''
    rm -rf $out/lib/systemd
  '';

  meta = {
    description = "Provides support for infrared cameras that are not directly enabled out-of-the box";
    homepage = "https://github.com/EmixamPP/linux-enable-ir-emitter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fufexan ];
    mainProgram = "linux-enable-ir-emitter";
    platforms = lib.platforms.linux;
  };
}
