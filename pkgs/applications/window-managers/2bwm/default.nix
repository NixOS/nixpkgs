{ stdenv, fetchFromGitHub, patches
, libxcb, xcbutilkeysyms, xcbutilwm
, libX11, xcbutil, xcbutilxrm }:

stdenv.mkDerivation rec {
  version = "0.2";
  name = "2bwm-${version}";

  src = fetchFromGitHub {
    owner  = "venam";
    repo   = "2bwm";
    rev    = "v${version}";
    sha256 = "1la1ixpm5knsj2gvdcmxzj1jfbzxvhmgzps4f5kbvx5047xc6ici";
  };

  # Allow users set their own list of patches
  inherit patches;

  buildInputs = [ libxcb xcbutilkeysyms xcbutilwm libX11 xcbutil xcbutilxrm ];

  installPhase = "make install DESTDIR=$out PREFIX=\"\"";

  meta = with stdenv.lib; {
    homepage = "https://github.com/venam/2bwm";
    description = "A fast floating WM written over the XCB library and derived from mcwm";
    license = licenses.mit;
    maintainers =  [ maintainers.sternenseemann ];
    platforms = platforms.unix;
  };
}
