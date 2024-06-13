{
  lib,
  stdenv,
  python3Packages,
  fetchPypi,
  autoPatchelfHook,
  libxcrypt-legacy,
}:

let
  platformInfos = {
    "x86_64-linux" = {
      platform = "manylinux1_x86_64";
      hash = "sha256-gr5z8VYkuCqgmcnyA01/Ez6aX9NrKR4MgA0Bc6IHnfs=";
    };
    "x86_64-darwin" = {
      platform = "macosx_10_9_universal2";
      hash = "sha256-5LsxeozPgInUC1QAxDSlr8NIfmRSl5BN+g9/ZYAxiRE=";
    };
  };
  platformInfo = platformInfos.${stdenv.system} or (throw "Unsupported platform ${stdenv.system}");
in
python3Packages.buildPythonApplication rec {
  pname = "sourcery";
  version = "1.16.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    inherit (platformInfo) platform hash;
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = [ libxcrypt-legacy ];

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
