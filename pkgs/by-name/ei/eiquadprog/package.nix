{
  boost,
  eigen,
  fetchFromGitHub,
  jrl-cmakemodules,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eiquadprog";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "stack-of-tasks";
    repo = "eiquadprog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ukYIc5ZCIDunXMyC44Dd1qac4Ku4pNv9p4ik+xyI0i0=";
  };

  outputs = [
    "out"
    "doc"
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags;

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs;
  buildInputs = [ jrl-cmakemodules ];
  propagatedBuildInputs = [ eigen ];
  checkInputs = [ boost ];

  doCheck = true;

  meta = {
    description = "C++ reimplementation of eiquadprog";
    homepage = "https://github.com/stack-of-tasks/eiquadprog";
    changelog = "https://github.com/stack-of-tasks/eiquadprog/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
