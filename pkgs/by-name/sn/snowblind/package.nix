{
  lib,
  stdenv,
  fetchFromGitLab,
  gtk-engine-murrine,
}:

stdenv.mkDerivation {
  pname = "snowblind";
  version = "2020-06-07";

  src = fetchFromGitLab {
    domain = "www.opencode.net";
    owner = "ju1464";
    repo = "snowblind";
    rev = "88d626b204e19d1730836289a1c0d83efcf247d0";
    sha256 = "0admiqwdc0rvl8zxs0b2qyvsi8im7lrpsygm8ky8ymyf7alkw0gd";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -a Snowblind* $out/share/themes
    rm $out/share/themes/*/{COPYING,CREDITS}
  '';

  meta = with lib; {
    description = "Smooth blue theme based on Materia Design";
    homepage = "https://www.opencode.net/ju1464/Snowblind";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
