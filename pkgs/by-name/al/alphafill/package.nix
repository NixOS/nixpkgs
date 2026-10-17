{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  date,
  libmcfp,
  libcifpp,
  libzeep,
  mrc,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "alphafill";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = "alphafill";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-vXzylvecsYDxmQ2r9W8aQsMYZqzY1mIIQLJHUCDWi9k=";
  };

  postPatch = ''
    sed -i 's/\(find_package([^ ]*\) [^ )]* QUIET)/\1)/g' CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    date
    libcifpp
    libmcfp
    libzeep
    mrc
    zlib
  ];

  meta = {
    homepage = "https://alphafill.eu";
    description = "Algorithm based on sequence and structure similarity that transplants missing compounds to the AlphaFold models";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.bsd2;
  };
})
