{ lib, stdenv, fetchFromGitHub, lazarus, fpc, pango, cairo, glib
, atk, gtk2, libX11, gdk-pixbuf, busybox, python3
, makeWrapper
}:

let
  bgrabitmap = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "bgrabitmap";
    rev = "2814b069d55f726b9f3b4774d85d00dd72be9c05";
    hash = "sha256-YibwdhlgjgI30gqYsKchgDPlOSpBiDBDJNlUDFMygGs=";
  };
  bgracontrols = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "bgracontrols";
    rev = "v8.0";
    hash = "sha256-5L05eGVN+xncd0/0XLFN6EL2ux4aAOsiU0BMoy0dKgg=";
  };
in stdenv.mkDerivation rec {
  pname = "lazpaint";
  version = "7.2.2-unstable-2024-01-20";

  src = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "lazpaint";
    rev = "fe54c2e2561c51218a5a2755842ce3fc2e0ebb35";
    hash = "sha256-LaOTJiS+COJUlyJiN9H2kEKwv5lbJqOHsUXOnb+IQFA=";
  };

  nativeBuildInputs = [ lazarus fpc makeWrapper ];

  buildInputs = [ pango cairo glib atk gtk2 libX11 gdk-pixbuf ];

  NIX_LDFLAGS = "--as-needed -rpath ${lib.makeLibraryPath buildInputs}";

  preConfigure = ''
    patchShebangs configure
  '';

  buildPhase = ''
    cp -r --no-preserve=mode ${bgrabitmap} bgrabitmap
    cp -r --no-preserve=mode ${bgracontrols} bgracontrols

    lazbuild --lazarusdir=${lazarus}/share/lazarus \
      --build-mode=Release \
      bgrabitmap/bgrabitmap/bgrabitmappack.lpk \
      bgracontrols/bgracontrols.lpk \
      lazpaintcontrols/lazpaintcontrols.lpk \
      lazpaint/lazpaint.lpi
  '';

  postBuild = ''
    # Python is needed for scripts
    wrapProgram $out/bin/lazpaint \
      --prefix PATH : ${lib.makeBinPath [ python3 ]}
  '';

  meta = with lib; {
    description = "Image editor like PaintBrush or Paint.Net";
    homepage = "https://lazpaint.github.io";
    downloadPage = "https://github.com/bgrabitmap/lazpaint/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
    mainProgram = "lazpaint";
  };
}
