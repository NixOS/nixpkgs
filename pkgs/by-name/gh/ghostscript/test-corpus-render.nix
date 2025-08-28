{
  stdenv,
  fetchgit,
  ghostscript,
}:

stdenv.mkDerivation {
  pname = "ghostscript-test-corpus-render";
  version = "unstable-2023-05-19";

  src = fetchgit {
    url = "git://git.ghostscript.com/tests.git";
    rev = "f7d5087d3d6c236707842dcd428818c6cb8fb041";
    hash = "sha256-xHOEo1ZJG1GCcEKqaXLDpfRRQxpbSy0bzicKju9hG40=";
  };

  dontConfigure = true;
  dontBuild = true;

  doCheck = true;
  checkPhase = ''
    find . -iregex '.*\.\(ps\|eps\|pdf\)' | while read f; do
      echo "Rendering $f"
      ${ghostscript}/bin/gs \
        -dNOPAUSE \
        -dBATCH \
        -sDEVICE=bitcmyk \
        -sOutputFile=/dev/null \
        -r600 \
        -dBufferSpace=100000 \
        $f
    done
  '';

  installPhase = ''
    touch $out
  '';
}
