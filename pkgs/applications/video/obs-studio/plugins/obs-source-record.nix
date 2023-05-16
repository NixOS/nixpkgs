<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, obs-studio }:

stdenv.mkDerivation rec {
  pname = "obs-source-record";
  version = "0.3.2";
=======
{ lib, stdenv, fetchFromGitHub, cmake, obs-studio }:

stdenv.mkDerivation rec {
  pname = "obs-source-record";
  version = "unstable-2022-11-10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-source-record";
<<<<<<< HEAD
    rev = version;
    sha256 = "sha256-H65uQ9HnKmHs52v3spG92ayeYH/TvmwcMoePMmBMqN8=";
  };

  patches = [
    # fix obs 29.1 compatibility
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/exeldro/obs-source-record/pull/83.diff";
      hash = "sha256-eWOjHHfoXZeoPtqvVyexSi/UQqHm8nu4FEEjma64Ly4=";
    })
  ];

=======
    rev = "4a543d3577d56a27f5f2b9aa541a466b37dafde0";
    sha256 = "sha256-LoMgrWZ7r6lu2fisNvqrAiFvxWQQDE6lSxUHkMB/ZPY=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    obs-studio
  ];

<<<<<<< HEAD
  NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated-declarations" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  cmakeFlags = [
    "-DBUILD_OUT_OF_TREE=On"
  ];

  postInstall = ''
    rm -rf $out/{data,obs-plugins}
  '';

  meta = with lib; {
    description = "OBS Studio plugin to make sources available to record via a filter";
    homepage = "https://github.com/exeldro/obs-source-record";
    maintainers = with maintainers; [ robbins ];
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
}
