{ stdenv, fetchFromGitHub, cmake, bpp-core, bpp-seq, bpp-phyl, bpp-popgen }:

stdenv.mkDerivation rec {
  pname = "bppsuite";

  inherit (bpp-core) version;

  src = fetchFromGitHub {
    owner = "BioPP";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wdwcgczqbc3m116vakvi0129wm3acln3cfc7ivqnalwvi6lrpds";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ bpp-core bpp-seq bpp-phyl bpp-popgen ];

  meta = bpp-core.meta // {
    homepage = "https://github.com/BioPP/bppsuite";
    changelog = "https://github.com/BioPP/bppsuite/blob/master/ChangeLog";
  };
}
