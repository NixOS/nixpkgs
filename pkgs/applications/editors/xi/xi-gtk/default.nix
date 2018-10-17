{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, gtk3, json-glib, vala, wrapGAppsHook, wrapXiFrontendHook }:

stdenv.mkDerivation rec {
  name = "xi-gtk-${version}";
  version = "2018-07-30";
  
  src = fetchFromGitHub {
    owner = "eyelash";
    repo = "xi-gtk";
    rev = "50fff217df29e5da82aaaf196d92009757ffb571";
    sha256 = "13r3i0z7j4jlv3n56nj76bx63zy9wh939j1rgjw1snw4q7v7s9x3";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [
    gtk3 json-glib vala
    wrapGAppsHook
    wrapXiFrontendHook
  ];

  postInstall = "wrapXiFrontend $out/bin/*";

  meta = with stdenv.lib; {
    description = "A GTK+ front-end for the Xi editor";
    homepage = https://github.com/eyelash/xi-gtk;
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
