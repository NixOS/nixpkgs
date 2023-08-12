{ lib, stdenv, fetchFromGitHub, lazarus, fpc, pango, cairo, glib
, atk, gtk2, libX11, gdk-pixbuf, busybox, python3, makeWrapper }:

with stdenv;

let
  bgrabitmap = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "bgrabitmap";
    rev = "v11.5.3";
    sha256 = "sha256-qjBD9TVZQy1tKWHFWkuu6vdLjASzQb3+HRy0FLdd9a8=";
  };
  bgracontrols = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "bgracontrols";
    rev = "v7.6";
    sha256 = "sha256-btg9DMdYg+C8h0H7MU+uoo2Kb4OeLHoxFYHAv7LbLBA=";
  };
in stdenv.mkDerivation rec {
  pname = "lazpaint";
  version = "7.2.2";

  src = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "lazpaint";
    rev = "v${version}";
    sha256 = "sha256-J6s0GnGJ7twEYW5+B72bB3EX4AYvLnhSPLbdhZWzlkw=";
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

  installPhase = ''
    # Reuse existing install script
    substituteInPlace Makefile --replace "/bin/bash" $BASH
    cd lazpaint/release/debian
    substituteInPlace makedeb.sh --replace "rm -rf" "ls"
    patchShebangs ./makedeb.sh
    PATH=$PATH:${busybox}/bin ./makedeb.sh
    cp -r staging/usr $out

    # Python is needed for scripts
    makeWrapper $out/share/lazpaint/lazpaint $out/bin/lazpaint \
      --prefix PATH : ${lib.makeBinPath [ python3 ]}
  '';

  meta = with lib; {
    description = "Image editor like PaintBrush or Paint.Net";
    homepage = "https://sourceforge.net/projects/lazpaint/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
