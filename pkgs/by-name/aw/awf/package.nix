{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gtk2,
  gtk3,
  pkg-config,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "awf";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "valr";
    repo = "awf";
    rev = "v${version}";
    sha256 = "0jl2kxwpvf2n8974zzyp69mqhsbjnjcqm39y0jvijvjb1iy8iman";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk2
    gtk3
  ];

  autoreconfPhase = ''
    patchShebangs ./autogen.sh
    ./autogen.sh
  '';

  meta = with lib; {
    description = "Widget Factory";
    longDescription = ''
      A widget factory is a theme preview application for gtk2 and
      gtk3. It displays the various widget types provided by gtk2/gtk3
      in a single window allowing to see the visual effect of the
      applied theme.
    '';
    homepage = "https://github.com/valr/awf";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ michalrus ];
  };
}
