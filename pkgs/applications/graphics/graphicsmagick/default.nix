{ lib, stdenv, fetchurl, bzip2, freetype, graphviz, ghostscript
, libjpeg, libpng, libtiff, libxml2, zlib, libtool, xz, libX11
, libwebp, quantumdepth ? 8, fixDarwinDylibNames, nukeReferences
, runCommand
, graphicsmagick  # for passthru.tests
}:

stdenv.mkDerivation rec {
  pname = "graphicsmagick";
  version = "1.3.39";

  src = fetchurl {
    url = "mirror://sourceforge/graphicsmagick/GraphicsMagick-${version}.tar.xz";
    sha256 = "sha256-4wscpY6HPQoe4gg4RyRCTbLTwzpUA04mHRTo+7j40E8=";
  };

  patches = [
    ./disable-popen.patch
  ];

  configureFlags = [
    "--enable-shared"
    "--with-frozenpaths"
    "--with-quantum-depth=${toString quantumdepth}"
    "--with-gslib=yes"
  ];

  buildInputs =
    [ bzip2 freetype ghostscript graphviz libjpeg libpng libtiff libX11 libxml2
      zlib libtool libwebp
    ];

  nativeBuildInputs = [ xz nukeReferences ]
  ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  # Remove CFLAGS from the binaries to avoid closure bloat.
  # In the past we have had -dev packages in the closure of the binaries soley due to the string references.
  postConfigure = ''
    nuke-refs -e $out ./magick/magick_config.h
  '';

  postInstall = ''
    sed -i 's/-ltiff.*'\'/\'/ $out/bin/*
  '';

  passthru = {
    tests = {
      issue-157920 = runCommand "issue-157920-regression-test" {
        buildInputs = [ graphicsmagick ];
      } ''
        gm convert ${graphviz}/share/graphviz/doc/pdf/neatoguide.pdf jpg:$out
      '';
    };
  };

  meta = {
    homepage = "http://www.graphicsmagick.org";
    description = "Swiss army knife of image processing";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "gm";
  };
}
