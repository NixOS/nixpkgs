{
  lib,
  stdenv,
  fetchurl,
  libpng,
  static ? stdenv.hostPlatform.isStatic,
}:

# This package comes with its own copy of zlib, libpng and pngxtern

stdenv.mkDerivation rec {
  pname = "optipng";
  version = "7.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/optipng/optipng-${version}.tar.gz";
    hash = "sha256-wleb5YwsZtrp1jFU7cs9Qn/vZMsA7Ar/B5ydFW7Ebyk=";
  };

  buildInputs = [ libpng ];

  # Workaround for crash in cexcept.h. See
  # https://github.com/NixOS/nixpkgs/issues/28106
  preConfigure = ''
    export LD=$CC
  '';

  # OptiPNG does not like --static, --build or --host
  dontDisableStatic = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [ ];

  configureFlags = [
    "--with-system-zlib"
    "--with-system-libpng"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    #"-prefix=$out"
  ];

  postInstall =
    if stdenv.hostPlatform != stdenv.buildPlatform && stdenv.hostPlatform.isWindows then
      ''
        mv "$out"/bin/optipng{,.exe}
      ''
    else
      null;

  meta = with lib; {
    homepage = "https://optipng.sourceforge.net/";
    description = "PNG optimizer";
    license = licenses.zlib;
    platforms = platforms.unix;
    mainProgram = "optipng";
  };
}
