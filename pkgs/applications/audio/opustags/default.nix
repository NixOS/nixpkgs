{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, libiconv, libogg
, ffmpeg, glibcLocales, perl, perlPackages }:

stdenv.mkDerivation rec {
  pname = "opustags";
<<<<<<< HEAD
  version = "1.9.0";
=======
  version = "1.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fmang";
    repo = "opustags";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-cRDyE6/nv8g0OWxZ/AqfwVrk3cSIycvbjvQm9CyQK7g=";
  };


  nativeBuildInputs = [ cmake pkg-config ]
    ++ lib.optionals stdenv.isDarwin [ libiconv ];

  buildInputs = [ libogg ];

  doCheck = true;

  nativeCheckInputs = [ ffmpeg glibcLocales perl ]
    ++ (with perlPackages; [ ListMoreUtils TestDeep ]);
=======
    sha256 = "sha256-qxtTJ4Hl2ccL+rhONeoOfV6ZyJaWaVDPMsXYJkXCWkY=";
  };

  buildInputs = [ libogg ];

  nativeBuildInputs = [ cmake pkg-config ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  doCheck = true;

  nativeCheckInputs = [ ffmpeg glibcLocales perl ] ++ (with perlPackages; [ ListMoreUtils ]);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  checkPhase = ''
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    make check
  '';

  meta = with lib; {
    homepage = "https://github.com/fmang/opustags";
    description = "Ogg Opus tags editor";
    platforms = platforms.all;
    broken = stdenv.isDarwin;
<<<<<<< HEAD
    maintainers = with maintainers; [ kmein ];
=======
    maintainers = with maintainers; [ kmein SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
  };
}
