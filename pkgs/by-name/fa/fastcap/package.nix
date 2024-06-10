{ stdenv
, fetchzip
, ghostscript
, lib
, texliveMedium
}:

stdenv.mkDerivation rec {
  pname = "fastcap";
  version = "2.0-18Sep92";

  src = fetchzip {
    url = "https://www.rle.mit.edu/cpg/codes/fastcap-${version}.tgz";
    hash = "sha256-fnmC6WNd7xk8fphxkMZUq2+Qz+2mWIP2lvBUBAmUvHI";
    stripRoot = false;
  };

  patches = [
    ./fastcap-mulglobal-drop-conflicting-lib.patch
    ./fastcap-mulsetup-add-forward-declarations.patch
  ];

  nativeBuildInputs = [
    ghostscript
    texliveMedium
  ];

  postPatch = ''
    substituteInPlace ./doc/Makefile \
      --replace '/bin/rm' 'rm'

    for f in "doc/*.tex" ; do
      sed -i -E $f \
        -e 's/\\special\{psfile=([^,]*),.*scale=([#0-9.]*).*\}/\\includegraphics[scale=\2]{\1}/' \
        -e 's/\\psfig\{figure=([^,]*),.*width=([#0-9.]*in).*\}/\\includegraphics[width=\2]{\1}/' \
        -e 's/\\psfig\{figure=([^,]*),.*height=([#0-9.]*in).*\}/\\includegraphics[height=\2]{\1}/' \
        -e 's/\\psfig\{figure=([^,]*)\}/\\includegraphics{\1}/'
    done

    for f in "doc/mtt.tex" "doc/tcad.tex" "doc/ug.tex"; do
      sed -i -E $f \
        -e 's/^\\documentstyle\[(.*)\]\{(.*)\}/\\documentclass[\1]{\2}\n\\usepackage{graphicx}\n\\usepackage{robinspace}/' \
        -e 's/\\setlength\{\\footheight\}\{.*\}/%/' \
        -e 's/\\setstretch\{.*\}/%/'
    done
  '';

  dontConfigure = true;

  makeFlags = [
    "RM=rm"
    "SHELL=sh"
    "all"
  ];

  outputs = [ "out" "doc" ];

  postBuild = ''
    make manual
    pushd doc
    find -name '*.dvi' -exec dvipdf {} \;
    popd
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    mv bin $out/bin
    rm $out/bin/README

    mkdir -p $doc/share/doc/fastcap-${version}
    cp doc/*.pdf $doc/share/doc/fastcap-${version}

    mkdir -p $out/share/fastcap
    mv examples $out/share/fastcap

    runHook postInstall
  '';

  meta = with lib; {
    description = "Multipole-accelerated capacitance extraction program";
    longDescription = ''
      Fastcap is  a three dimensional capacitance extraction program that
      compute self and mutual capacitances between conductors of arbitrary
      shapes, sizes and orientations.
      '';
    homepage = "https://www.rle.mit.edu/cpg/research_codes.htm";
    license = licenses.mit;
    maintainers = with maintainers; [ fbeffa ];
    platforms = platforms.linux;
    mainProgram = "fastcap";
  };
}
