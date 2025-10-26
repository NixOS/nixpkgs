{
  stdenv,
  fetchFromGitHub,
  cmake,
  texinfo,
  bpp-core,
  bpp-seq,
  bpp-phyl,
  bpp-popgen,
}:

stdenv.mkDerivation rec {
  pname = "bppsuite";

  inherit (bpp-core) version postPatch;

  src = fetchFromGitHub {
    owner = "BioPP";
    repo = "bppsuite";
    rev = "v${version}";
    sha256 = "1wdwcgczqbc3m116vakvi0129wm3acln3cfc7ivqnalwvi6lrpds";
  };

  nativeBuildInputs = [
    cmake
    texinfo
  ];
  buildInputs = [
    bpp-core
    bpp-seq
    bpp-phyl
    bpp-popgen
  ];

  meta = bpp-core.meta // {
    homepage = "https://github.com/BioPP/bppsuite";
    changelog = "https://github.com/BioPP/bppsuite/blob/master/ChangeLog";
  };
}
