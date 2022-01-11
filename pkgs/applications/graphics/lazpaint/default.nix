{ lib, stdenv, fetchFromGitHub, lazarus, fpc, pango, cairo, glib
, atk, gtk2, libX11, gdk-pixbuf, busybox, python3, makeWrapper }:

with stdenv;

let
  bgrabitmap = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "bgrabitmap";
    rev = "v11.2.5";
    sha256 = "0w5pdihsxn039kalkf4cx23j69hz5r09qmhd358h2n74irv1r3x1";
  };
  bgracontrols = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "bgracontrols";
    rev = "v7.0";
    sha256 = "0qz3cscrc9jvhrix1hbmzhdxv6mxk0mz9azr46canflsydda8fjy";
  };
in stdenv.mkDerivation rec {
  pname = "lazpaint";
  version = "7.1.5";

  src = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "lazpaint";
    rev = "v${version}";
    sha256 = "0bpk3rlqzbxvgrxmrzs0hcrgwhsqnpjqv1kdd9cp09knimmksvy5";
  };

  nativeBuildInputs = [ lazarus fpc makeWrapper ];

  buildInputs = [ pango cairo glib atk gtk2 libX11 gdk-pixbuf ];

  NIX_LDFLAGS = "--as-needed -rpath ${lib.makeLibraryPath buildInputs}";

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
