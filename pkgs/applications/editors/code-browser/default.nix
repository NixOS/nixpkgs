{ lib, stdenv
, fetchurl
, copper
, python3
, pkg-config
, withQt ? false, qtbase ? null, wrapQtAppsHook ? null
, withGtk2 ? false, gtk2
, withGtk3 ? false, gtk3
, mkDerivation ? stdenv.mkDerivation
}:
let onlyOneEnabled = xs: 1 == builtins.length (builtins.filter lib.id xs);
in assert onlyOneEnabled [ withQt withGtk2 withGtk3 ];
mkDerivation rec {
  pname = "code-browser";
  version = "8.0";
  src = fetchurl {
    url = "https://tibleiz.net/download/code-browser-${version}-src.tar.gz";
    sha256 = "sha256-beCp4lx4MI1+hVgWp2h3piE/zu51zfwQdB5g7ImgmwY=";
  };
  postPatch = ''
    substituteInPlace Makefile --replace "LFLAGS=-no-pie" "LFLAGS=-no-pie -L."
    patchShebangs .
  ''
  + lib.optionalString withQt ''
    substituteInPlace libs/copper-ui/Makefile --replace "moc -o" "${qtbase.dev}/bin/moc -o"
    substituteInPlace libs/copper-ui/Makefile --replace "all: qt gtk gtk2" "all: qt"
  ''
  + lib.optionalString withGtk2 ''
    substituteInPlace libs/copper-ui/Makefile --replace "all: qt gtk gtk2" "all: gtk2"
  ''
  + lib.optionalString withGtk3 ''
    substituteInPlace libs/copper-ui/Makefile --replace "all: qt gtk gtk2" "all: gtk"
  ''
  ;
  nativeBuildInputs = [ copper
                        python3
                        pkg-config
                      ]
  ++ lib.optionals withGtk2 [ gtk2 ]
  ++ lib.optionals withGtk3 [ gtk3 ]
  ++ lib.optionals withQt [ qtbase wrapQtAppsHook ];
  buildInputs = lib.optionals withQt [ qtbase ]
                ++ lib.optionals withGtk2 [ gtk2 ]
                ++ lib.optionals withGtk3 [ gtk3 ];
  makeFlags = [
    "prefix=$(out)"
    "COPPER=${copper}/bin/copper-elf64"
    "with-local-libs"
  ]
  ++ lib.optionals withQt [ "QINC=${qtbase.dev}/include"
                            "UI=qt"
                          ]
  ++ lib.optionals withGtk2 [ "UI=gtk2" ]
  ++ lib.optionals withGtk3 [ "UI=gtk" ];

  meta = with lib; {
    description = "Folding text editor, designed to hierarchically structure any kind of text file and especially source code";
    homepage = "https://tibleiz.net/code-browser/";
    license = licenses.gpl2;
    platforms = platforms.x86_64;
  };
}
