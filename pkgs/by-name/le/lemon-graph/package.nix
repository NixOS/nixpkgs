{
  lib,
  stdenv,
  fetchurl,
  cmake,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lemon-graph";
  version = "1.3.1";

  src = fetchurl {
    url = "https://lemon.cs.elte.hu/pub/sources/lemon-${finalAttrs.version}.tar.gz";
    sha256 = "1j6kp9axhgna47cfnmk1m7vnqn01hwh7pf1fp76aid60yhjwgdvi";
  };

  buildInputs = [ python3 ];
  nativeBuildInputs = [ cmake ];

  # error: no viable conversion from ...
  doCheck = !stdenv.hostPlatform.isDarwin;

  patches = [
    # error: ISO C++17 does not allow 'register' storage class specifier
    ./remove-register.patch

    # fix cmake compatibility. vendored from https://github.com/The-OpenROAD-Project/lemon-graph/pull/2
    ./cmake_version.patch

    # fix C++20 compatibility. vendored from https://github.com/The-OpenROAD-Project/lemon-graph/commit/f871b10396270cfd09ffddc4b6ead07722e9c232
    ./update_cxx20.patch
  ];

  meta = {
    homepage = "https://lemon.cs.elte.hu/trac/lemon";
    description = "Efficient library for combinatorial optimization tasks on graphs and networks";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ trepetti ];
    platforms = lib.platforms.all;
  };
})
