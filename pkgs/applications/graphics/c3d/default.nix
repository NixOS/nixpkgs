{ stdenv, fetchgit, cmake, itk, Cocoa }:

stdenv.mkDerivation rec {
  pname   = "c3d";
  version = "2018-10-04";

  src = fetchgit {
    url = "https://git.code.sf.net/p/c3d/git";
    rev = "351929a582b2ef68fb9902df0b11d38f44a0ccd0";
    sha256 = "0mpv4yl6hdnxgvnwrmd182h64n3ppp30ldzm0jz6jglk0nvpzq9w";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ itk ]
    ++ stdenv.lib.optional stdenv.isDarwin Cocoa;

  meta = with stdenv.lib; {
    homepage = http://www.itksnap.org/c3d;
    description = "Medical imaging processing tool";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.gpl2;
    broken = true;
  };
}
