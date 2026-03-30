{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "25.04";
  pname = "intel-cmt-cat";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-cmt-cat";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Sbxfa9F+TSv2A8nilrB0PD312v1qN++k8Pezd7wd0PA=";
  };

  enableParallelBuilding = true;

  makeFlags = [
    "PREFIX=$(out)"
    "NOLDCONFIG=y"
  ];

  meta = {
    description = "User space software for Intel(R) Resource Director Technology";
    homepage = "https://github.com/intel/intel-cmt-cat";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ arkivm ];
    platforms = [ "x86_64-linux" ];
  };
})
