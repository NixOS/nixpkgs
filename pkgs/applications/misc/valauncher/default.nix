{ stdenv, fetchFromGitHub, cmake, gtk3, vala, pkgconfig, gnome3 }:

stdenv.mkDerivation rec {
  version = "1.3.1";
  name = "valauncher-${version}";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "valauncher";
    rev = "v${version}";
    sha256 = "18969v870737jg1q0l3d05pb9mxsrcpdi0mnyz94rwkspszvxxqi";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake gtk3 vala gnome3.libgee ];

  meta = with stdenv.lib; {
      description = "A fast dmenu-like gtk3 application launcher";
      homepage = https://github.com/Mic92/valauncher;
      license = licenses.mit;
      maintainers = with maintainers; [ mic92 ];
      platforms = platforms.all;
  };
}
