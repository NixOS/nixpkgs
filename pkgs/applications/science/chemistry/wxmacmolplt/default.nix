{ stdenv
, lib
, fetchFromGitHub
, wxGTK32
, libGL
, libGLU
, pkg-config
, xorg
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "wxmacmolplt";
  version = "7.7.2";

  src = fetchFromGitHub {
    owner = "brettbode";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sNxCjIEJUrDWtcUqBQqvanNfgNQ7T4cabYy+x9D1U+Q=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [
    wxGTK32
    libGL
    libGLU
    xorg.libX11
    xorg.libX11.dev
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Graphical user inteface for GAMESS-US";
    homepage = "https://brettbode.github.io/wxmacmolplt/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sheepforce markuskowa ];
  };
}
