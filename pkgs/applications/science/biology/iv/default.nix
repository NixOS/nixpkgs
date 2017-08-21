{ stdenv, fetchurl, neuron-version
, libX11, libXext, patchelf
}:

stdenv.mkDerivation rec
  { name = "iv-19";
    src = fetchurl
      { url = "http://www.neuron.yale.edu/ftp/neuron/versions/v${neuron-version}/${name}.tar.gz";
        sha256 = "1q22vjngvn3m61mjxynkik7pxvsgc9a0ym46qpa84hmz1v86mdrw";
      };
    nativeBuildInputs = [ patchelf ];
    buildInputs = [ libXext ];
    propagatedBuildInputs = [ libX11 ];
    hardeningDisable = [ "format" ];
    postInstall = ''
      for dir in $out/*; do # */
        if [ -d $dir/lib ]; then
	  mv $dir/* $out # */
          rmdir $dir
          break
        fi
      done
      patchelf --add-needed ${libX11}/lib/libX11.so $out/lib/libIVhines.so
    '';
    meta = with stdenv.lib;
      { description = "InterViews graphical library for Neuron";
        license     = licenses.bsd3;
        homepage    = http://www.neuron.yale.edu/neuron;
        platforms   = platforms.all;
      };
  }
