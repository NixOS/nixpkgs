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

  prePatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "1.2.4" "" \
      --replace-fail "6.0.11" "" \
      --replace-fail "QUIET" ""
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost date libcifpp libmcfp libzeep mrc zlib ];

  meta = {
    homepage = "alphafill.eu";
    description = ''
      Algorithm based on sequence and structure similarity
      that transplants missing compounds to the AlphaFold models
    '';
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.bsd2;
  };
})
