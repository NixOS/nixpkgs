{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  python3,
  alsa-utils,
  timidity,
}:

stdenv.mkDerivation rec {
  version = "25.05.0";
  pname = "mma";

  src = fetchurl {
    url = "https://www.mellowood.ca/mma/mma-bin-${version}.tar.gz";
    sha256 = "sha256-J72uTwAlWa/dRPf7/lO1epbmjTQar+3/U//+IJ9u4PM=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    python3
    alsa-utils
    timidity
  ];

  patchPhase = ''
    sed -i 's@/usr/bin/aplaymidi@/${alsa-utils}/bin/aplaymidi@g' mma-splitrec
    sed -i 's@/usr/bin/aplaymidi@/${alsa-utils}/bin/aplaymidi@g' util/mma-splitrec.py
    sed -i 's@/usr/bin/arecord@/${alsa-utils}/bin/arecord@g' mma-splitrec
    sed -i 's@/usr/bin/arecord@/${alsa-utils}/bin/arecord@g' util/mma-splitrec.py
    sed -i 's@/usr/bin/timidity@/${timidity}/bin/timidity@g' mma-splitrec
    sed -i 's@/usr/bin/timidity@/${timidity}/bin/timidity@g' util/mma-splitrec.py
    find . -type f | xargs sed -i 's@/usr/bin/env python@${python3.interpreter}@g'
    find . -type f | xargs sed -i 's@/usr/bin/python3@${python3.interpreter}@g'
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
    cp -r {docs,egs,includes,lib,MMA,text,plugins} $out/share/mma

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
    homepage = "https://www.mellowood.ca/mma/index.html";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
