{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "megahit";
  version = "1.2.9";

  src = fetchFromGitHub {
    owner = "voutcn";
    repo = "megahit";
    rev = "v${version}";
    sha256 = "1r5d9nkdmgjsbrpj43q9hy3s8jwsabaz3ji561v18hy47v58923c";
  };

  patches = [
    # Fix gcc-13 build failure:
    #   https://github.com/voutcn/megahit/pull/366
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/voutcn/megahit/commit/4cb2f793503087163bda8592222f105f27e33e66.patch";
      hash = "sha256-b5mhzif+OPcMjmg+BnaUc5CB6Acn/KTBOJEw+WYEhbs=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isStatic [
    "-DSTATIC_BUILD=ON"
  ];
  meta = with lib; {
    description = "Ultra-fast single-node solution for large and complex metagenomics assembly via succinct de Bruijn graph";
    license = licenses.gpl3;
    homepage = "https://github.com/voutcn/megahit";
    maintainers = with maintainers; [ luispedro ];
    platforms = [ "x86_64-linux" ];
  };
}
