{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "iprange";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/firehol/iprange/releases/download/v${version}/iprange-${version}.tar.xz";
    sha256 = "sha256-VJFhSZV0ugGy3VZFLKIslPHvTMGAAaNYtRm1gAzxCTw=";
  };

  meta = {
    description = "Manage IP ranges";
    mainProgram = "iprange";
    homepage = "https://github.com/firehol/iprange";
    license = lib.licenses.gpl2;
    maintainers = [ ];
  };
}
