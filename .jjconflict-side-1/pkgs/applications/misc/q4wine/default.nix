{ lib, fetchFromGitHub, mkDerivation, cmake, sqlite
, qtbase, qtsvg, qttools, wrapQtAppsHook
, icoutils # build and runtime deps.
, wget, fuseiso, wine, which # runtime deps.
}:

mkDerivation rec {
  pname = "q4wine";
  version = "1.3.13";

  src = fetchFromGitHub {
    owner = "brezerk";
    repo = "q4wine";
    rev = "v${version}";
    sha256 = "04gw5y3dxdpivm2xqacqq85fdzx7xkl0c3h3hdazljb0c3cxxs6h";
  };

  buildInputs = [
     sqlite icoutils qtbase qtsvg qttools
  ];

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  # Add runtime deps.
  postInstall = ''
    wrapProgram $out/bin/q4wine \
      --prefix PATH : ${lib.makeBinPath [ icoutils wget fuseiso wine which ]}
  '';

  meta = with lib; {
    homepage = "https://q4wine.brezblock.org.ua/";
    description = "Qt GUI for Wine to manage prefixes and applications";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rkitover ];
    platforms = platforms.unix;
  };
}
