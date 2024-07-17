{
  lib,
  stdenv,
  fetchurl,
  neuron-version,
  libX11,
  libXext,
  patchelf,
}:

stdenv.mkDerivation rec {
  pname = "iv";
  version = "19";

  src = fetchurl {
    url = "https://www.neuron.yale.edu/ftp/neuron/versions/v${neuron-version}/iv-${version}.tar.gz";
    sha256 = "07a3g8zzay4h0bls7fh89dd0phn7s34c2g15pij6dsnwpmjg06yx";
  };

  nativeBuildInputs = [ patchelf ];
  buildInputs = [ libXext ];
  propagatedBuildInputs = [ libX11 ];

  hardeningDisable = [ "format" ];

  postInstall =
    ''
      for dir in $out/*; do # */
        if [ -d $dir/lib ]; then
          mv $dir/* $out # */
          rmdir $dir
          break
        fi
      done
    ''
    + lib.optionalString stdenv.isLinux ''
      patchelf --add-needed ${libX11}/lib/libX11.so $out/lib/libIVhines.so
    '';

  meta = with lib; {
    description = "InterViews graphical library for Neuron";
    license = licenses.bsd3;
    homepage = "http://www.neuron.yale.edu/neuron";
    platforms = platforms.all;
  };
}
