{ stdenv, fetchFromGitHub, lazarus, fpc, pango, cairo, glib
, atk, gtk2, libX11, gdk-pixbuf, busybox, python3, makeWrapper }:

with stdenv;

let
  bgrabitmap = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "bgrabitmap";
    rev = "v11.1";
    sha256 = "0bcmiiwly4a7w8p3m5iskzvk8rz87qhc0gcijrdvwg87cafd88gz";
  };
  bgracontrols = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "bgracontrols";
    rev = "v6.7.2";
    sha256 = "0cwxzv0rl6crkf6f67mvga5cn5pyhr6ksm8cqhpxjiqi937dnyxx";
  };
in stdenv.mkDerivation rec {
  pname = "lazpaint";
  version = "7.1.3";

  src = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "lazpaint";
    rev = "v${version}";
    sha256 = "1sfb5hmhzscz3nv4cmc192jimkg70l4z3q3yxkivhw1hwwsv9cbg";
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
      --prefix PATH : ${stdenv.lib.makeBinPath [ python3 ]}

    substituteInPlace $out/share/applications/lazpaint.desktop \
      --replace /usr/share/pixmaps/lazpaint.png $out/share/pixmaps/lazpaint.png \
      --replace /usr/share/lazpaint/lazpaint $out/bin/lazpaint
  '';

  meta = with stdenv.lib; {
    description = "Image editor like PaintBrush or Paint.Net";
    homepage = "https://sourceforge.net/projects/lazpaint/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}
