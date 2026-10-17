{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amrwb";
  version = "11.0.0.0";

  strictDeps = true;
  __structuredAttrs = true;

  srcAmr = fetchurl {
    url = "http://www.3gpp.org/ftp/Specs/archive/26_series/26.204/26204-b00.zip";
    hash = "sha256-yIXERIP9RQLTVOyWVvLNwEaQUAFQUvjz7MHV4IyGn+w=";
  };

  src = fetchurl {
    url = "https://slackware.uk/sbosrcarch/by-name/audio/amrwb/amrwb-${finalAttrs.version}.tar.bz2";
    hash = "sha256-XK9ZsUSAsM0qe6u4vkcsSvOf9MfJXxJ4EWVXBJpN1dw=";
  };

  nativeBuildInputs = [ unzip ];

  configureFlags = [
    "--cache-file=config.cache"
    "--with-downloader=true"
  ];

  postConfigure = ''
    cp $srcAmr 26204-b00.zip
  '';

  meta = {
    homepage = "http://www.penguin.cz/~utx/amr";
    description = "AMR Wide-Band Codec";
    # The wrapper code is free, but not the libraries from 3gpp.
    # It's a source code reference implementation with patents and licenses on
    # some countries, not redistributable.
    license = lib.licenses.unfree;
  };
})
