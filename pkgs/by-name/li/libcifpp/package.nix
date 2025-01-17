{ lib
, stdenv
, boost
, cmake
, fetchFromGitHub
, fetchurl
, eigen
, zlib
, downloadCCDFile ? false
}:

let
  ccd-file = stdenv.mkDerivation (finalAttrs: {
    pname = "ccd-file";
    version = "20250101";
    src = fetchurl {
      url = "ftp://snapshots.wwpdb.org/${finalAttrs.version}/pub/pdb/data/monomers/components.cif.gz";
      hash = "sha256-2bJpHBYaZiKF13HXKWZen6YqA4tJeBy31zu+HrlC+Fw=";
    };
    unpackPhase = ''
      runHook preUnpack

      mkdir -p $out/share
      gunzip -c $src > $out/share/components.cif

      runHook postUnpack
    '';
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libcifpp";
  version = "7.0.8";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = "libcifpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PD811D/n++PM45H/BatlLiMaIeUEiisLU/bGhiUhPU0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    # The CCD file is huge. (> 400 MB)
    (lib.cmakeBool "CIFPP_DOWNLOAD_CCD" downloadCCDFile)
  ];

  preConfigure = lib.optionalString downloadCCDFile ''
    cp ${ccd-file}/share/components.cif rsrc/components.cif
  '';

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
    changelog = "https://github.com/PDB-REDO/libcifpp/releases/tag/v${finalAttrs.version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
})
