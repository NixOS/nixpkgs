{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation {
  pname = "amrnb";
  version = "11.0.0.0";
  srcAmr = fetchurl {
    url = "https://www.3gpp.org/ftp/Specs/latest/Rel-11/26_series/26104-b00.zip";
    hash = "sha256-I9+LJLDwCXgwJ7ju9fqCJexx+FnycEvbBoKfCQGMyPE=";
  };

  src = fetchurl {
    url = "https://web.archive.org/web/20230317115833if_/http://www.penguin.cz/~utx/ftp/amr/amrnb-11.0.0.0.tar.bz2";
    hash = "sha256-OJAAS2ZSeLlj7Kri3BMh3O4pxT6p2RqvGNkoYQXg8eE=";
  };

  nativeBuildInputs = [ unzip ];

  configureFlags = [
    "--cache-file=config.cache"
    "--with-downloader=true"
  ];

  postConfigure = ''
    cp $srcAmr 26104-b00.zip
  '';

  meta = {
    homepage = "http://www.penguin.cz/~utx/amr";
    description = "AMR Narrow-Band Codec";
    # The wrapper code is free, but not the libraries from 3gpp.
    # It's a source code reference implementation with patents and licenses on
    # some countries, not redistributable.
    license = lib.licenses.unfree;
  };
}
