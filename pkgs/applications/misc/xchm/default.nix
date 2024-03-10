{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, wxGTK32
, chmlib
}:

stdenv.mkDerivation rec {
  pname = "xchm";
  version = "1.36";

  src = fetchFromGitHub {
    owner = "rzvncj";
    repo = "xCHM";
    rev = version;
    sha256 = "sha256-+RbFE/jOD8sofHMCFgTIfgokrXYqDbCSSnN6SdEZ/b0=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    wxGTK32
    chmlib
  ];

  configureFlags = [ "--with-wx-prefix=${wxGTK32}" ];

  preConfigure = ''
    export LDFLAGS="$LDFLAGS $(${wxGTK32}/bin/wx-config --libs | sed -e s@-pthread@@) -lwx_gtk3u_aui-3.2"
  '';

  meta = with lib; {
    description = "A viewer for Microsoft HTML Help files";
    homepage = "https://github.com/rzvncj/xCHM";
    license = licenses.gpl2;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
    mainProgram = "xchm";
  };
}
