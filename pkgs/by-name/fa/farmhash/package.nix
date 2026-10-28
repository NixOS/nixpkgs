{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "farmhash";
  version = "1.1.0-unstable-2019-05-13";

  src = fetchFromGitHub {
    owner = "google";
    repo = "farmhash";
    rev = "0d859a811870d10f53a594927d0d0b97573ad06d";
    hash = "sha256-J0AhHVOvPFT2SqvQ+evFiBoVfdHthZSBXzAhUepARfA=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ autoreconfHook ];
  configureFlags = [ "--enable-shared" ];
  env.CXXFLAGS = "-std=c++14";

  doCheck = true;

  meta = {
    description = "Family of hash functions from Google";
    homepage = "https://github.com/google/farmhash";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
