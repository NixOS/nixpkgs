{ lib
, stdenv
, fetchFromGitHub
, giflib
, imlib2
, libXft
, libexif
, libwebp
, conf ? null
}:

stdenv.mkDerivation rec {
  pname = "nsxiv";
  version = "29";

  src = fetchFromGitHub {
    owner = "nsxiv";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JUF2cF6QeAXk6G76uMu3reaMgxp2RcqHDbamkNufwqE=";
  };

  buildInputs = [
    giflib
    imlib2
    libXft
    libexif
    libwebp
  ];

  preBuild = lib.optionalString (conf!=null) ''
    cp ${(builtins.toFile "config.def.h" conf)} config.def.h
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    homepage = "https://nsxiv.github.io/nsxiv/";
    description = "New Suckless X Image Viewer";
    longDescription = ''
      nsxiv is a fork of now unmaintained sxiv with the purpose of being a
      drop-in replacement of sxiv, maintaining it and adding simple, sensible
      features, like:

      - Basic image operations, e.g. zooming, panning, rotating
      - Customizable key and mouse button mappings (in config.h)
      - Script-ability via key-handler
      - Thumbnail mode: grid of selectable previews of all images
      - Ability to cache thumbnails for fast re-loading
      - Basic support for animated/multi-frame images (GIF/WebP)
      - Display image information in status bar
      - Display image name/path in X title
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
