{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, wxGTK30, boost, lua, zlib
, bzip2, xylib, readline, gnuplot, swig3 }:

let
  name    = "fityk";
  version = "1.3.1";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchFromGitHub {
    owner = "wojdyr";
    repo = "fityk";
    rev = "v${version}";
    sha256 = "0kmrjjjwrh6xgw590awcd52b86kksmv6rfgih75zvpiavr1ygwsi";
  };

  patches = [
    # Allow building with GTK 3
    (fetchpatch {
      url = "https://salsa.debian.org/science-team/fityk/raw/67b995963dba56914d25ab3bbcd420fcba24861d/debian/patches/permit-gtk3.patch";
      sha256 = "12by8w0gd0n8qkljn7lhlz9lhdswpkygkpszm77anrqz54hd3gqr";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ wxGTK30 boost lua zlib bzip2 xylib readline
    gnuplot swig3 ];

  meta = {
    description = "Curve fitting and peak fitting software";
    license = stdenv.lib.licenses.gpl2;
    homepage = http://fityk.nieto.pl/;
    platforms = stdenv.lib.platforms.linux;
  };
}
