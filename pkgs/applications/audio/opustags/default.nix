{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, libiconv, libogg
, ffmpeg, glibcLocales, perl, perlPackages }:

stdenv.mkDerivation rec {
  pname = "opustags";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "fmang";
    repo = "opustags";
    rev = version;
    sha256 = "sha256-cRDyE6/nv8g0OWxZ/AqfwVrk3cSIycvbjvQm9CyQK7g=";
  };


  nativeBuildInputs = [ cmake pkg-config ]
    ++ lib.optionals stdenv.isDarwin [ libiconv ];

  buildInputs = [ libogg ];

  doCheck = true;

  nativeCheckInputs = [ ffmpeg glibcLocales perl ]
    ++ (with perlPackages; [ ListMoreUtils TestDeep ]);

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
    maintainers = with maintainers; [ kmein ];
    license = licenses.bsd3;
  };
}
