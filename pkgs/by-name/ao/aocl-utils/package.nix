{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "aocl-utils";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "amd";
    repo = "aocl-utils";
    rev = version;
    hash = "sha256-tjmCgVSU4XjBhbKMUY3hsvj3bvuXvVdf5Bqva5nr1tc=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Interface to all AMD AOCL libraries to access CPU features";
    homepage = "https://github.com/amd/aocl-utils";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.markuskowa ];
  };
}
