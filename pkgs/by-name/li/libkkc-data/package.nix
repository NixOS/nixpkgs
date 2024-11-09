{ lib, stdenv, fetchurl, fetchpatch, python3, libkkc }:

stdenv.mkDerivation rec {
  pname = "libkkc-data";
  version = "0.2.7";

  src = fetchurl {
    url = "${meta.homepage}/releases/download/v${libkkc.version}/${pname}-${version}.tar.xz";
    sha256 = "16avb50jasq2f1n9xyziky39dhlnlad0991pisk3s11hl1aqfrwy";
  };

  patches = [
    (fetchpatch {
      name = "build-python3.patch";
      url = "https://github.com/ueno/libkkc/commit/ba1c1bd3eb86d887fc3689c3142732658071b5f7.patch";
      relative = "data/templates/libkkc-data";
      hash = "sha256-q4zUclJtDQ1E5v2PW00zRZz6GXllLUcp2h3tugufrRU=";
    })
  ];

  nativeBuildInputs = [ python3.pkgs.marisa ];

  strictDeps = true;

  meta = with lib; {
    description = "Language model data package for libkkc";
    homepage    = "https://github.com/ueno/libkkc";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ vanzef ];
    platforms   = platforms.linux;
  };
}
