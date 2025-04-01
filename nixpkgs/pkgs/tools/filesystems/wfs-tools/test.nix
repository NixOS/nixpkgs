{ lib
, stdenv
, wfs-tools
}:

stdenv.mkDerivation {
  name = "wfs-tools-test";

  buildCommand = ''
    # Test that all binaries are present and executable
    ${wfs-tools}/bin/wfs-fuse --help
    ${wfs-tools}/bin/wfs-extract --help
    ${wfs-tools}/bin/wfs-info --help
    ${wfs-tools}/bin/wfs-reencryptor --help
    ${wfs-tools}/bin/wfs-file-injector --help

    touch $out
  '';
} 