{ stdenv
, faust
, libjack2
, cargo
, binutils
, gcc
, gnumake
, openssl
, pkgconfig

}:

faust.wrapWithBuildEnv {

  baseName = "faust2jackrust";

  propagatedBuildInputs = [ libjack2 cargo binutils gcc gnumake openssl pkgconfig ];
}
