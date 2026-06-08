{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sptk";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "sp-nitech";
    repo = "SPTK";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QdaXIFsFXL9/CtUJlOaUKOTmG/nm6ibBEsVfzW9pT/U=";
  };

  patches = [
    # fix dangling symlinks: https://github.com/sp-nitech/SPTK/pull/90
    (fetchpatch {
      name = "fix-dangling.patch";
      url = "https://github.com/sp-nitech/SPTK/commit/8798c94d19e930c0947a7d1d0bc9e59a02aab567.patch";
      hash = "sha256-G7yyJ0uiVzcP6wQVwiDpWVZOJmOpKZRfNyoETt3xam4=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    (python3.withPackages (ps: [
      ps.numpy
      ps.plotly
      ps.scipy
    ]))
  ];

  doCheck = true;

  meta = {
    changelog = "https://github.com/sp-nitech/SPTK/releases/tag/v${finalAttrs.version}";
    description = "Suite of speech signal processing tools";
    homepage = "https://github.com/sp-nitech/SPTK";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
