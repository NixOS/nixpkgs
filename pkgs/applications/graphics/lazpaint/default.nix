{ stdenv, fetchFromGitHub, lazarus, fpc, pango, cairo, glib
, atk, gtk2, libX11, gdk-pixbuf, busybox, python3, makeWrapper }:

with stdenv;

let
  bgrabitmap = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "bgrabitmap";
    rev = "v11.2.4";
    sha256 = "1zk88crfn07md16wg6af4i8nlx4ikkhxq9gfk49jirwimgwbf1md";
  };
  bgracontrols = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "bgracontrols";
    rev = "v6.9";
    sha256 = "0hwjlqlwqs4fqxlgay84hccs1lm3c6i9nmq9sxzrip410mggnjyw";
  };
in stdenv.mkDerivation rec {
  pname = "lazpaint";
  version = "7.1.4";

  src = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "lazpaint";
    rev = "v${version}";
    sha256 = "19b0wrjjyvz3g2d2gdsz8ihc1clda5v22yb597an8j9sblp9m0nf";
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
