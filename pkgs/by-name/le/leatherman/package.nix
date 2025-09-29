{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  curl,
  ruby,
}:

stdenv.mkDerivation rec {
  pname = "leatherman";
  version = "1.12.13";

  src = fetchFromGitHub {
    sha256 = "sha256-rfh4JLnLekx9UhyLH6eDJUeItPROmY/Lc6mcWpbGb3s=";
    rev = version;
    repo = "leatherman";
    owner = "puppetlabs";
  };

  cmakeFlags = [ "-DLEATHERMAN_ENABLE_TESTING=OFF" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    curl
    ruby
  ];

  meta = {
    homepage = "https://github.com/puppetlabs/leatherman/";
    description = "Collection of C++ and CMake utility libraries";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.womfoo ];
    platforms = lib.platforms.unix;
  };

}
