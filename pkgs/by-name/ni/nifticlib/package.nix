{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nifticlib";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "NIFTI-Imaging";
    repo = "nifti_clib";
    rev = "v${finalAttrs.version}";
    sha256 = "0hamm6nvbjdjjd5md4jahzvn5559frigxaiybnjkh59ckxwb1hy4";
  };

  cmakeFlags = [ "-DDOWNLOAD_TEST_DATA=OFF" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  checkPhase = ''
    runHook preCheck
    ctest -LE 'NEEDS_DATA'
    runHook postCheck
  '';
  doCheck = true;

  meta = {
    homepage = "https://nifti-imaging.github.io";
    description = "Medical imaging format C API";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.publicDomain;
  };
})
