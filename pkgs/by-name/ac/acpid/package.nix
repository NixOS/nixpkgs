{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "acpid";
  version = "2.0.34";

  src = fetchurl {
    url = "mirror://sourceforge/acpid2/acpid-${version}.tar.xz";
    sha256 = "sha256-LQlcjPy8hHyux0bWLNyNC/8ewbxy73xnTHIeBNpqszM=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/acpid2/";
    description = "Daemon for delivering ACPI events to userspace programs";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
