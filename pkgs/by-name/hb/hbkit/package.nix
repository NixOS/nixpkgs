{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  lz4,
  versionCheckHook,
}:

let
  # hbkit dlopen()s liblz4 by name instead of linking it, and nothing is on a default
  # library search path here, so point it straight at the store path.
  liblz4 = "${lz4.lib}/lib/liblz4${stdenv.hostPlatform.extensions.sharedLibrary}";
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "hbkit";
  version = "0.5.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "YordiLorenzo";
    repo = "hbkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rRZzUesdD4G7G89QJiwgfBwaiXV/SpLaDHZZ8GfxD84=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    textual
    pynacl
    cryptography
  ];

  makeWrapperArgs = [
    "--set"
    "HBK_LZ4"
    liblz4
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  # without it the tests that extract from synthetic archives skip themselves
  preCheck = ''
    export HBK_LZ4="${liblz4}"
  '';

  pythonImportsCheck = [ "hbkit" ];

  meta = {
    description = "Recover files from Synology Hyper Backup (.hbk) archives";
    longDescription = ''
      hbkit reads Synology Hyper Backup archives directly, without a NAS or any
      Synology software. It restores the original directory tree and mtimes,
      verifies every chunk against the checksums stored in the archive, and can
      read client-side encrypted archives given the password. Includes a
      full-screen browser (hbk-tui) and can work against an archive kept in S3 or
      R2 over an rclone mount.
    '';
    homepage = "https://github.com/YordiLorenzo/hbkit";
    changelog = "https://github.com/YordiLorenzo/hbkit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "hbk";
    maintainers = with lib.maintainers; [ yordilorenzo ];
  };
})
