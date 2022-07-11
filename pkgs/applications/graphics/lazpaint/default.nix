{ lib
, stdenv
, fetchFromGitHub
, lazarus
, fpc
, pango
, cairo
, glib
, atk
, gtk2
, libX11
, gdk-pixbuf
, busybox
, python3
, makeWrapper
}:

let

  bgrabitmap = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "bgrabitmap";
    rev = "v11.5.1";
    sha256 = "sha256-2VpZLI+e3hF3cZNJMdvwKdl31kbBkNedh45ER7Wvs0w=";
  };
  bgracontrols = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "bgracontrols";
    rev = "v7.6";
    sha256 = "sha256-btg9DMdYg+C8h0H7MU+uoo2Kb4OeLHoxFYHAv7LbLBA=";
  };

in stdenv.mkDerivation rec {
  pname = "lazpaint";
  version = "7.2";

  src = fetchFromGitHub {
    owner = "bgrabitmap";
    repo = "lazpaint";
    rev = "v${version}";
    sha256 = "sha256-N6bymCS1MXLBIWu7fCTfCpYTAU5qsFCz1QLgWRLGL8w=";
  };

  postPatch = ''
    patchShebangs configure
  '';

  nativeBuildInputs = [
    fpc
    lazarus
    makeWrapper
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk2
    libX11
    pango
  ];

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

  postInstall = ''
    # Python is needed for scripts
    wrapProgram $out/bin/lazpaint \
      --prefix PATH : ${lib.makeBinPath [ python3 ]}
  '';

  meta = with lib; {
    # Fails to start
    # https://github.com/bgrabitmap/lazpaint/issues/515
    broken = true;
    description = "Image editor like PaintBrush or Paint.Net";
    homepage = "https://lazpaint.github.io";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
