{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corto";
  version = "2025.07";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "corto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wfIZQdypBTfUZJgPE4DetSt1SUNSyZihmL1Uzapqh1o=";
  };

  patches = [
    # CMake: exports
    # ref. https://github.com/cnr-isti-vclab/corto/pull/47
    # merged upstream
    (fetchpatch {
      name = "cmake-exports.patch";
      url = "https://github.com/cnr-isti-vclab/corto/commit/169356e97b29587b278822118aef34ed742b6b37.patch";
      hash = "sha256-imJfQ8JEhCcSkkO35N7Z3NtGElCyVxENPMDMWfNqdW0=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  updateScript = nix-update-script { };

  meta = {
    description = "Mesh compression library, designed for rendering and speed";
    homepage = "https://github.com/cnr-isti-vclab/corto";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "corto";
  };
})
