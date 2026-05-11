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
    sha256 = "1wf8ih0hk7w20vdlnw7jb7w73v15hbxgbvmq4wq7h2ghn0j8ppr3";
  };

  src = fetchurl {
    url = "http://www.penguin.cz/~utx/ftp/amr/amrnb-11.0.0.0.tar.bz2";
    sha256 = "1qgiw02n2a6r32pimnd97v2jkvnw449xrqmaxiivjy2jcr5h141q";
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
