{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "amrwb";
  version = "11.0.0.0";

  srcAmr = fetchurl {
    url = "http://www.3gpp.org/ftp/Specs/archive/26_series/26.204/26204-b00.zip";
    sha256 = "1v4zhs6f1mf1xkrzhljh05890in0rpr5d5pcak9h4igxhd2c91f8";
  };

  src = fetchurl {
    url = "http://www.penguin.cz/~utx/ftp/amr/amrwb-${version}.tar.bz2";
    sha256 = "1p6m9nd08mv525w14py9qzs9zwsa5i3vxf5bgcmcvc408jqmkbsw";
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
}
