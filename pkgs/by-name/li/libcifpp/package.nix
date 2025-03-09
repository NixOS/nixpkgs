{ lib
, stdenv
, boost
, cmake
, fetchFromGitHub
, eigen
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcifpp";
  version = "7.0.8";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = "libcifpp";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-PD811D/n++PM45H/BatlLiMaIeUEiisLU/bGhiUhPU0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    # disable network access
    "-DCIFPP_DOWNLOAD_CCD=OFF"
  ];

  buildInputs = [
    boost
    eigen
    zlib
  ];

  # cmake requires the existence of this directory when building dssp
  postInstall = ''
    mkdir -p $out/share/libcifpp
  '';

  meta = with lib; {
    description = "Manipulate mmCIF and PDB files";
    homepage = "https://github.com/PDB-REDO/libcifpp";
    changelog = "https://github.com/PDB-REDO/libcifpp/releases/tag/${lib.removePrefix "refs/tags/" finalAttrs.src.rev}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
})
