{ faust
, libjack2
, cargo
, binutils
, gcc
, gnumake
, openssl
, pkg-config

}:

faust.wrapWithBuildEnv {

  baseName = "faust2jackrust";

  propagatedBuildInputs = [ libjack2 cargo binutils gcc gnumake openssl pkg-config ];
}
