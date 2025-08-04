{
  lib,
  stdenv,
  fetchurl,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "lemon-graph";
  version = "1.3.1";

  src = fetchurl {
    url = "https://lemon.cs.elte.hu/pub/sources/lemon-${version}.tar.gz";
    sha256 = "1j6kp9axhgna47cfnmk1m7vnqn01hwh7pf1fp76aid60yhjwgdvi";
  };

  nativeBuildInputs = [ cmake ];

  # error: no viable conversion from ...
  doCheck = !stdenv.hostPlatform.isDarwin;

  patches = [
    # error: ISO C++17 does not allow 'register' storage class specifier
    ./remove-register.patch
  ];

  meta = {
    homepage = "https://lemon.cs.elte.hu/trac/lemon";
    description = "Efficient library for combinatorial optimization tasks on graphs and networks";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ trepetti ];
    platforms = lib.platforms.all;
  };
}
