{ stdenv, fetchFromGitHub, cmake, gtk3, vala_0_26, pkgconfig, gnome3 }:

stdenv.mkDerivation rec {
  version = "1.2";
  name = "valauncher-${version}";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "valauncher";
    rev = "v${version}";
    sha256 = "1d1gfmzmr5ra2rnjc6rbz31mf3hk7q04lh4i1hljgk7fh90dacb6";
  };

  buildInputs = [ cmake gtk3 vala_0_26 pkgconfig gnome3.libgee ];

  meta = with stdenv.lib; {
      description = "A fast dmenu-like gtk3 application launcher";
      homepage = https://github.com/Mic92/valauncher;
      license = licenses.mit;
      maintainers = with maintainers; [ mic92 ];
      platforms = platforms.all;
  };
}
