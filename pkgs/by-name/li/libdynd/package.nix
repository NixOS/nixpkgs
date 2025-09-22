{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "libdynd";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "libdynd";
    repo = "libdynd";
    rev = "v${version}";
    sha256 = "0fkd5rawqni1cq51fmr76iw7ll4fmbahfwv4rglnsabbkylf73pr";
  };

  cmakeFlags = [
    "-DDYND_BUILD_BENCHMARKS=OFF"
  ];

  env.NIX_CFLAGS_COMPILE = builtins.toString [
    # added to fix build with gcc7+
    "-Wno-error=implicit-fallthrough"
    "-Wno-error=nonnull"
    "-Wno-error=tautological-compare"
    "-Wno-error=class-memaccess"
    "-Wno-error=parentheses"
    "-Wno-error=deprecated-copy"
    # Needed with GCC 12
    "-Wno-error=deprecated-declarations"
    "-Wno-error=maybe-uninitialized"
  ];

  nativeBuildInputs = [ cmake ];

  outputs = [
    "out"
    "dev"
  ];
  outputDoc = "dev";

  meta = with lib; {
    description = "C++ dynamic ndarray library, with Python exposure";
    homepage = "http://libdynd.org";
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
