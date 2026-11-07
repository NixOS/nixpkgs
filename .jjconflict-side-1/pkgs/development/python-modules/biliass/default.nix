{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
  libiconv,
}:

# r-ryantm wants to downgrade
# nixpkgs-update: no auto update
buildPythonPackage rec {
  pname = "biliass";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yutto-dev";
    repo = "yutto";
    tag = "biliass@${version}";
    hash = "sha256-6lSXex9UOJn2bR6gigSBV4l1ecwtOIkYaK6YKVh3xpY=";
  };

  sourceRoot = "${src.name}/packages/biliass";
  cargoRoot = "rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      cargoRoot
      ;
    hash = "sha256-GwmQOrv2wOT/yLtMlU6FBNbtp1wfEHn8wM0Yfmxs3eE=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  doCheck = false; # test artifacts missing

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "biliass" ];

  meta = {
    homepage = "https://github.com/yutto-dev/biliass";
    description = "Convert Bilibili XML/protobuf danmaku to ASS subtitle";
    mainProgram = "biliass";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ linsui ];
  };
}
