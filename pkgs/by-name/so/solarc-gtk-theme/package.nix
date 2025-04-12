{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  pkg-config,
  gtk-engine-murrine,
  gtk3,
}:

stdenv.mkDerivation {
  pname = "solarc-gtk-theme";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "schemar";
    repo = "solarc-theme";
    rev = "d1eb117325b8e5085ecaf78df2eb2413423fc643";
    sha256 = "005b66whyxba3403yzykpnlkz0q4m154pxpb4jzcny3fggy9r70s";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
    gtk3
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
    gtk3
  ];

  buildPhase = ''
    ./autogen.sh --prefix=$out
  '';

  meta = with lib; {
    description = "Solarized version of the Arc theme";
    homepage = "https://github.com/schemar/solarc-theme";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
