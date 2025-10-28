{
  lib,
  stdenv,
  python3Packages,
  fetchPypi,
  autoPatchelfHook,
  zlib,
}:

let
  platformInfos = {
    "x86_64-linux" = {
      platform = "manylinux1_x86_64";
      hash = "sha256-tnRFcgMgHGcWtTGPFZZPkE9IKDfvejLmvvD2iwPbbLY=";
    };
    "x86_64-darwin" = {
      platform = "macosx_10_9_universal2";
      hash = "sha256-6dbLiFUku0F+UiFV6P6nXpR6dezSntriVJyTfFaIgP0=";
    };
  };

  inherit (stdenv.hostPlatform) system;
  platformInfo = platformInfos.${system} or (throw "Unsupported platform ${system}");
in
python3Packages.buildPythonApplication rec {
  pname = "sourcery";
  version = "1.37.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    inherit (platformInfo) platform hash;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [ zlib ];

  meta = {
    changelog = "https://sourcery.ai/changelog/";
    description = "AI-powered code review and pair programming tool for Python";
    downloadPage = "https://pypi.org/project/sourcery/";
    homepage = "https://sourcery.ai";
    license = lib.licenses.unfree;
    mainProgram = "sourcery";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
