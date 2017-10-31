{ stdenv, fetchurl, makeWrapper, python, alsaUtils, timidity }:

  stdenv.mkDerivation rec {
  version = "15.12";
  name = "mma-${version}";

  src = fetchurl {
    url = "http://www.mellowood.ca/mma/mma-bin-${version}.tar.gz";
    sha256 = "0k37kcrfaxmwjb8xb1cbqinrkx3g50dbvwqbvwl3l762j4vr8jgx";
  };

  buildInputs = [ makeWrapper python alsaUtils timidity ];

  patchPhase = ''
    sed -i 's@/usr/bin/aplaymidi@/${alsaUtils}/bin/aplaymidi@g' mma-splitrec
    sed -i 's@/usr/bin/aplaymidi@/${alsaUtils}/bin/aplaymidi@g' util/mma-splitrec.py
    sed -i 's@/usr/bin/arecord@/${alsaUtils}/bin/arecord@g' mma-splitrec
    sed -i 's@/usr/bin/arecord@/${alsaUtils}/bin/arecord@g' util/mma-splitrec.py
    sed -i 's@/usr/bin/timidity@/${timidity}/bin/timidity@g' mma-splitrec
    sed -i 's@/usr/bin/timidity@/${timidity}/bin/timidity@g' util/mma-splitrec.py
    find . -type f | xargs sed -i 's@/usr/bin/env python@${python}/bin/python@g'
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/mma,share/man/man1,share/man/man8}
    mkdir -p $out/etc

    cp mma.py $out/bin/mma
    cp mma-gb $out/bin/mma-gb
    cp mma-libdoc $out/bin/mma-libdoc
    cp mma-renum $out/bin/mma-renum
    cp mma-splitrec $out/bin/mma-splitrec
    cp util/mma-mnx.py $out/bin/mma-mnx
    cp util/mma-rm2std.py $out/bin/mma-rm2std
    cp util/mmatabs.py $out/bin/mmatabs
    cp util/mup2mma.py $out/bin/mup2mma
    cp util/pg2mma.py $out/bin/pg2mma
    cp util/synthsplit.py $out/bin/mma-synthsplit
    cp -r {docs,egs,includes,lib,MMA,text} $out/share/mma
    rmdir $out/share/mma/includes/aria

    cp util/README.* $out/share/mma/docs
    mv $out/share/mma/docs/man/mma-libdoc.8 $out/share/man/man8
    mv $out/share/mma/docs/man/mma-renum.1 $out/share/man/man1
    mv $out/share/mma/docs/man/mma.1 $out/share/man/man1
    mv $out/share/mma/docs/man/mma-gb.1 $out/share/man/man1
    rm -rf $out/share/mma/docs/man
    find $out -type f | xargs sed -i "s@/usr/share/mma@$out/share/mma@g"
  '';

  preFixup = ''
    PYTHONPATH=$out/share/mma/:$PYTHONPATH
    for f in $out/bin/*; do
          wrapProgram $f \
           --prefix PYTHONPATH : $PYTHONPATH
    done
    cd $out/share/mma/
    $out/bin/mma -G
  '';

  meta = {
    description = "Creates MIDI tracks for a soloist to perform over from a user supplied file containing chords";
    homepage =  http://www.mellowood.ca/mma/index.html;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
