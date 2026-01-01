{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "libucontext";
<<<<<<< HEAD
  version = "1.5";
=======
  version = "1.3.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "kaniini";
    repo = "libucontext";
    rev = "libucontext-${version}";
<<<<<<< HEAD
    hash = "sha256-asT0pV3s4L4zB2qtDJ+2XYxEP6agIEo1LtCuFeOjpRA=";
=======
    hash = "sha256-MQCRRyA64MEtPoUtf1tFVbhiMDc4DlepSjMEFcb/Kh4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru.updateScript = nix-update-script { };

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/kaniini/libucontext";
    description = "ucontext implementation featuring glibc-compatible ABI";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.lix ];
=======
  meta = with lib; {
    homepage = "https://github.com/kaniini/libucontext";
    description = "ucontext implementation featuring glibc-compatible ABI";
    license = licenses.isc;
    platforms = platforms.linux;
    teams = [ teams.lix ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
