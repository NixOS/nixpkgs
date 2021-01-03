{ stdenv, fetchFromGitHub, fetchpatch, cmake, pkg-config, libiconv, libogg
, ffmpeg, glibcLocales, perl, perlPackages }:

stdenv.mkDerivation rec {
  pname = "opustags";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "fmang";
    repo = "opustags";
    rev = version;
    sha256 = "1dicv4s395b9gb4jpr0rnxdq9azr45pid62q3x08lb7cvyq3yxbh";
  };

  patches = [
    # Fix building on darwin
    (fetchpatch {
      url = "https://github.com/fmang/opustags/commit/64fc6f8f6d20e034892e89abff0236c85cae98dc.patch";
      sha256 = "1djifzqhf1w51gbpqbndsh3gnl9iizp6hppxx8x2a92i9ns22zpg";
    })
    (fetchpatch {
      url = "https://github.com/fmang/opustags/commit/f98208c1a1d10c15f98b127bbfdf88a7b15b08dc.patch";
      sha256 = "1h3v0r336fca0y8zq1vl2wr8gaqs3vvrrckx7pvji4k1jpiqvp38";
    })
  ];

  buildInputs = [ libogg ];

  nativeBuildInputs = [ cmake pkg-config ] ++ stdenv.lib.optional stdenv.isDarwin libiconv;

  doCheck = true;

  checkInputs = [ ffmpeg glibcLocales perl ] ++ (with perlPackages; [ ListMoreUtils ]);

  checkPhase = ''
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    make check
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/fmang/opustags";
    description = "Ogg Opus tags editor";
    platforms = platforms.all;
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ kmein SuperSandro2000 ];
    license = licenses.bsd3;
  };
}
