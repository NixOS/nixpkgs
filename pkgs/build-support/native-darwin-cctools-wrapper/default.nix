{stdenv}:

stdenv.mkDerivation {
  name = "native-darwin-cctools-wrapper";

  # Standard binaries normally found under /usr/bin (MIG is omitted here, and
  # handled specially in ./builder.sh).
  binaries =
    [ "ar" "as" "c++filt" "gprof" "ld" "nm" "nmedit" "ranlib"
      "size" "strings" "strip" "dsymutil" "libtool" "lipo"
      "install_name_tool" "arch" "sw_vers"
    ];

  builder = ./builder.sh;
}
