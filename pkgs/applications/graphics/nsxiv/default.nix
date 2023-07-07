{ lib
, stdenv
, fetchFromGitea
, giflib
, imlib2
, libXft
, libexif
, libwebp
, libinotify-kqueue
, conf ? null
}:

stdenv.mkDerivation rec {
  pname = "nsxiv";
  version = "31";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "nsxiv";
    repo = "nsxiv";
    rev = "v${version}";
    hash = "sha256-X1ZMr5OADs9GIe/kp/kEqKMMHZMymd58m9+f0SPzn7s=";
  };

  buildInputs = [
    giflib
    imlib2
    libXft
    libexif
    libwebp
  ] ++ lib.optional stdenv.isDarwin libinotify-kqueue;

  preBuild = lib.optionalString (conf!=null) ''
    cp ${(builtins.toFile "config.def.h" conf)} config.def.h
  '';

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-linotify";

  makeFlags = [ "CC:=$(CC)" ];

  installFlags = [ "PREFIX=$(out)" ];

  installTargets = [ "install-all" ];

  meta = with lib; {
    homepage = "https://nsxiv.codeberg.page/";
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
    maintainers = with maintainers; [ AndersonTorres sikmir ];
    platforms = platforms.unix;
    changelog = "https://codeberg.org/nsxiv/nsxiv/src/tag/${src.rev}/etc/CHANGELOG.md";
  };
}
