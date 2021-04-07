{ lib, stdenv
, fetchurl
, copper
, ruby
, python3
, qtbase
, gtk3
, pkg-config
, withQt ? false
, withGtk ? false, wrapQtAppsHook ? null
}:
stdenv.mkDerivation rec {
  pname = "code-browser";
  version = "7.1.20";
  src = fetchurl {
    url = "https://tibleiz.net/download/code-browser-${version}-src.tar.gz";
    sha256 = "1svi0v3h42h2lrb8c7pjvqc8019v1p20ibsnl48pfhl8d96mmdnz";
  };
  postPatch = ''
    substituteInPlace Makefile --replace "LFLAGS=-no-pie" "LFLAGS=-no-pie -L."
    substituteInPlace libs/copper-ui/Makefile --replace "moc -o" "${qtbase.dev}/bin/moc -o"
    patchShebangs .
  '';
  nativeBuildInputs = [ copper
                        python3
                        ruby
                        qtbase
                        gtk3
                        pkg-config
                      ]
  ++ lib.optionals withQt [ wrapQtAppsHook ];
  buildInputs = lib.optionals withQt [ qtbase ]
                ++ lib.optionals withGtk [ gtk3 ];
  makeFlags = [
    "prefix=$(out)"
    "COPPER=${copper}/bin/copper-elf64"
    "with-local-libs"
    "QINC=${qtbase.dev}/include"
  ]
  ++ lib.optionals withQt [ "UI=qt" ]
  ++ lib.optionals withGtk [ "UI=gtk" ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Folding text editor, designed to hierarchically structure any kind of text file and especially source code";
    homepage = "https://tibleiz.net/code-browser/";
    license = licenses.gpl2;
    platforms = platforms.x86_64;
  };
}
