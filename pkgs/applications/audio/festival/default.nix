{ stdenv
, fetchurl
, speech-tools
, autoreconfHook
, alsaLib
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "festival";
  inherit (speech-tools) version;

  srcs =  [
    (fetchurl {
      url = "http://festvox.org/packed/festival/${stdenv.lib.versions.majorMinor version}/festival-${version}-release.tar.gz";
      sha256 = "1d5415nckiv19adxisxfm1l1xxfyw88g87ckkmcr0lhjdd10g42c";
    })
    (speech-tools.src)
  ];

  sourceRoot = "festival";

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    alsaLib
    ncurses
  ];

  postPatch = ''
    find .. -type f | xargs sed -i -e 's!/bin/rm!rm!;s!/usr/bin/printf!printf!'
    patchShebangs config
  '';

  preConfigure = ''
    pushd ../speech_tools
    autoreconf -fi
    ./configure
    make all
    popd
  '';

  installPhase = ''
    mkdir -p "$out"/{bin,lib}
    for d in bin lib; do
      for i in ./$d/*; do
        test "$(basename "$i")" = "Makefile" ||
          cp -r "$(readlink -f $i)" "$out/$d"
      done
    done
  '';

  meta = with stdenv.lib; {
    description = "Framework for building speech synthesis systems";
    homepage = "http://www.cstr.ed.ac.uk/projects/festival/";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
  };
}
