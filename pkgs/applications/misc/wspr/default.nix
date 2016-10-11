{ stdenv, fetchFromGitHub, pkgconfig, gfortran, portaudio
, pythonFull, swig2, pythonPackages, fftwFloat, libsamplerate, tk

}:

stdenv.mkDerivation rec {
  name = "wspr-${version}";
  version = "4.0";

  buildInputs = [ pkgconfig gfortran portaudio fftwFloat libsamplerate tk pythonFull (with pythonPackages; [ numpy tkinter pmw pillow ])];

#  propagatedBuildInputs = [
#    numpy scipy matplotlib
#  ];

  propagatedBuildInputs = [
    pythonPackages.tkinter
    pythonPackages.pmw
    pythonPackages.numpy
    pythonPackages.pillow
  ];

  src = fetchFromGitHub {
    owner = "jj1bdx";
    repo = "wspr";
    rev = "78cf9932e75446e0a8face90570674cf5ddad9f4";
    sha256 = "0fxip023cgq3223ahr17fnmxqmjb9iy994xjbfvf69g5jwqjnprp";
  };

  configureFlags = [ "--with-portaudio-include-dir=${portaudio}/include --with-portaudio-lib-dir=${portaudio}/lib" ];
 
  installPhase = ''
    rm -rf  build
    grep -rl Numeric . | xargs sed -i 's/Numeric/numpy/'
    grep -rl "import Image, ImageDraw" . | xargs sed -i 's/import Image, ImageDraw/from PIL import Image, ImageDraw/'
    grep -rl "import Image, ImageTk, ImageDraw" . | xargs sed -i 's/import Image, ImageTk, ImageDraw/from PIL import Image, ImageTk, ImageDraw/'
    ${pythonFull}/bin/${pythonFull.executable} setup.py install --prefix=$out
    cp -a WsprModNoGui $out/lib/${pythonFull.libPrefix}/site-packages/
    cp wspr_nogui.py $out/bin/
    cp tkrep.py $out/bin/
    echo "#!/bin/sh" > $out/bin/wspr
    echo "LD_LIBRARY_PATH=$out/lib \\" >> $out/bin/wspr
    echo PYTHONPATH=$PYTHONPATH:${pythonPackages.pillow}/lib/${pythonFull.libPrefix}/site-packages:$(toPythonPath "$out") \\ >> $out/bin/wspr
    echo "${pythonFull}/bin/${pythonFull.executable} -O $out/bin/wspr.py" >> $out/bin/wspr
    chmod +x $out/bin/wspr
    chmod -x $out/bin/wspr.py
  '';


  meta = with stdenv.lib; {
    description = "WSPR generator";
    homepage = https://github.com/jj1bdx/wspr;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.mog ];
  };
}
