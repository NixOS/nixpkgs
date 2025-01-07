{
  lib,
  stdenv,
  fetchFromGitHub,
  binutils-unwrapped,
  patchelf,
  asterisk,
}:
stdenv.mkDerivation rec {
  pname = "asterisk-module-sccp";
  version = "4.3.5";

  src = fetchFromGitHub {
    owner = "chan-sccp";
    repo = "chan-sccp";
    rev = "v${version}";
    sha256 = "sha256-Lonsh7rx3C17LU5pZpZuFxlki0iotDt+FivggFJbldU=";
  };

  nativeBuildInputs = [ patchelf ];

  configureFlags = [ "--with-asterisk=${asterisk}" ];

  installFlags = [
    "DESTDIR=/build/dest"
    "DATAROOTDIR=/build/dest"
  ];

  postInstall = ''
    mkdir -p "$out"
    cp -r /build/dest/${asterisk}/* "$out"
  '';

  postFixup = ''
    p="$out/lib/asterisk/modules/chan_sccp.so"
    patchelf --set-rpath "$p:${lib.makeLibraryPath [ binutils-unwrapped ]}" "$p"
  '';

  meta = {
    description = "Replacement for the SCCP channel driver in Asterisk";
    license = lib.licenses.gpl1Only;
    maintainers = with lib.maintainers; [ das_j ];
  };
}
