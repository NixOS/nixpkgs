{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gtk2,
  libhangul,
  autoconf,
  automake,
}:

stdenv.mkDerivation rec {
  pname = "nabi";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "libhangul";
    repo = "nabi";
    tag = "nabi-${version}";
    hash = "sha256-C6K8sXVCGf45VZtGSCB5emFzZPV21kG9JxAwBHRiFsY=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
  ];

  buildInputs = [
    gtk2
    libhangul
  ];

  postPatch = ''
    patchShebangs ./autogen.sh
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  meta = {
    description = "Easy Hangul XIM";
    mainProgram = "nabi";
    homepage = "https://github.com/libhangul/nabi";
    changelog = "https://github.com/libhangul/nabi/blob/nabi-${version}/NEWS";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ianwookim ];
    platforms = lib.platforms.linux;
  };
}
