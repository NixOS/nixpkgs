{ stdenv, pkgconfig, gtk2, keybinder, fetchFromGitLab }:

stdenv.mkDerivation {
  name = "fehlstart-9f4342d7";

  src = fetchFromGitLab {
    owner = "fehlstart";
    repo = "fehlstart";
    rev = "9f4342d75ec5e2a46c13c99c34894bc275798441";
    sha256 = "1rfzh7w6n2s9waprv7m1bhvqrk36a77ada7w655pqiwkhdj5q95i";
  };

  patches = [ ./use-nix-profiles.patch ];
  buildInputs = [ pkgconfig gtk2 keybinder ];

  preConfigure = ''
    export PREFIX=$out
  '';

  meta = with stdenv.lib; {
    description = "Small desktop application launcher with reasonable memory footprint";
    homepage = https://gitlab.com/fehlstart/fehlstart;
    licence = licenses.gpl3;
    maintainers = [ maintainers.mounium ];
    platforms = platforms.all;
  };
}
