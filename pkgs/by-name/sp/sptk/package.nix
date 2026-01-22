{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "sptk";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "sp-nitech";
    repo = "SPTK";
    rev = "v${version}";
    hash = "sha256-lIyOcN2AR3ilUZ9stpicjbwlredbwgGPwmMICxZEijU=";
  };

  patches = [
    # Fix gcc-13 build failure:
    #   https://github.com/sp-nitech/SPTK/pull/57
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/sp-nitech/SPTK/commit/060bc2ad7a753c1f9f9114a70d4c4337b91cb7e0.patch";
      hash = "sha256-QfzpIS63LZyTHAaMGUZh974XLRNZLQG3om7ZJJ4RlgE=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  doCheck = true;

  meta = {
    changelog = "https://github.com/sp-nitech/SPTK/releases/tag/v${version}";
    description = "Suite of speech signal processing tools";
    homepage = "https://github.com/sp-nitech/SPTK";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
