{
  stdenv,
  fetchFromGitHub,
  lib,
  vdr,
}:
stdenv.mkDerivation rec {
  pname = "vdr-streamdev";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "vdr-projects";
    repo = "vdr-plugin-streamdev";
    rev = version;
    sha256 = "sha256-12sASyFAnSuP2xQzr1KL/Am52ez6hiOUH/0zFH2bxhc=";
  };

  # configure don't accept argument --prefix
  dontAddPrefix = true;

  makeFlags = [
    "DESTDIR=$(out)"
    "LIBDIR=/lib/vdr"
    "LOCDIR=/share/locale"
  ];

  enableParallelBuilding = true;

  buildInputs = [
    vdr
  ];

  meta = {
    inherit (src.meta) homepage;
    description = "This PlugIn is a VDR implementation of the VTP (Video Transfer Protocol) Version 0.0.3 (see file PROTOCOL) and a basic HTTP Streaming Protocol";
    maintainers = [ lib.maintainers.ck3d ];
    license = lib.licenses.gpl2;
    inherit (vdr.meta) platforms;
  };
}
