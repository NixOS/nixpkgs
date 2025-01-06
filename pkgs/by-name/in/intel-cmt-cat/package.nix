{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  version = "24.05";
  pname = "intel-cmt-cat";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-cmt-cat";
    rev = "v${version}";
    sha256 = "sha256-e4sbQNpUCZaZDhLLRVDXHXsEelZaZIdc8n3ksUnAkKQ=";
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
}
