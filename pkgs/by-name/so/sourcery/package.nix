{
  lib,
  stdenv,
  python3Packages,
  fetchPypi,
  autoPatchelfHook,
  zlib,
}:

let
  inherit (stdenv.hostPlatform) system;
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "sourcery";
  version = "1.43.0";
  format = "wheel";

  passthru.sources =
    let
      fetchWheel =
        { platform, hash }:
        fetchPypi {
          format = "wheel";
          inherit (finalAttrs) pname version;
          inherit platform hash;
        };
    in
    {
      "x86_64-linux" = fetchWheel {
        platform = "manylinux1_x86_64";
        hash = "sha256-oUL7EVbfwgV1K1Rv0kzW5r1AXr167BCXwzntDgVyTc0=";
      };
      "x86_64-darwin" = fetchWheel {
        platform = "macosx_10_9_x86_64";
        hash = "sha256-Ynn1BUBrmzRV2sL5ZGwOEQ/ccoV0edwFt4iiz9KN+k8=";
      };
      "aarch64-darwin" = fetchWheel {
        platform = "macosx_11_0_arm64";
        hash = "sha256-iQNOSoAClAk2FMjAExfgsFHDXS56vwieePGDCYRRbgQ=";
      };
    };

  src = finalAttrs.passthru.sources.${system} or (throw "Unsupported platform ${system}");

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
    platforms = lib.attrNames finalAttrs.passthru.sources;
  };
})
