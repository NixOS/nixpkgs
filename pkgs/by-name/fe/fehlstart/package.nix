{
  lib,
  stdenv,
  pkg-config,
  gtk2,
  keybinder,
  fetchFromGitLab,
}:

stdenv.mkDerivation {
  pname = "fehlstart";
  version = "unstable-2016-05-23";

  src = fetchFromGitLab {
    owner = "fehlstart";
    repo = "fehlstart";
    rev = "9f4342d75ec5e2a46c13c99c34894bc275798441";
    sha256 = "1rfzh7w6n2s9waprv7m1bhvqrk36a77ada7w655pqiwkhdj5q95i";
  };

  patches = [ ./use-nix-profiles.patch ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk2
    keybinder
  ];

  preConfigure = ''
    export PREFIX=$out
  '';

  meta = with lib; {
    description = "Small desktop application launcher with reasonable memory footprint";
    homepage = "https://gitlab.com/fehlstart/fehlstart";
    license = licenses.gpl3;
    maintainers = [ maintainers.mounium ];
    platforms = platforms.all;
    mainProgram = "fehlstart";
  };
}
