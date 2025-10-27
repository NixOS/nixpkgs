{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
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

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Mesh compression library, designed for rendering and speed";
    homepage = "https://github.com/cnr-isti-vclab/corto";
    license = licenses.mit;
    maintainers = with maintainers; [ nim65s ];
  };
})
