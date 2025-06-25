{
  lib,
  stdenv,
  boost,
  cmake,
  fetchFromGitHub,
  eigen,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcifpp";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = "libcifpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cfyou+R0VrAfYM8ez5myZkDKO5VfB9WAQF+amy3oRzU=";
  };

  nativeBuildInputs = [ cmake ];

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

  meta = {
    description = "Manipulate mmCIF and PDB files";
    homepage = "https://github.com/PDB-REDO/libcifpp";
    changelog = "https://github.com/PDB-REDO/libcifpp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = lib.platforms.unix;
  };
})
