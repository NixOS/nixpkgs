{
  lib,
  fetchFromGitHub,
  rustPlatform,
  coreutils,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gungraun-runner";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "gungraun";
    repo = "gungraun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sjHAcdBONdMpbpZkgFPeFfE6H46Jr9uPtWVegAPH3BA=";
  };

  cargoHash = "sha256-+7z3VSBR0o5B5pg/hbVDqaR1/higLPsxfHGygHG6eXg=";

  buildAndTestSubdir = "crates/gungraun-runner";

  postPatch = ''
    substituteInPlace crates/gungraun-runner/src/runner/args.rs \
      --replace-fail "/bin/cat" "${lib.getExe' coreutils "cat"}"
  '';

  __structuredAttrs = true;

  meta = {
    description = "High-precision, one-shot and consistent benchmarking framework/harness for Rust. All Valgrind tools at your fingertips.";
    mainProgram = "gungraun-runner";
    homepage = "https://gungraun.github.io/gungraun/latest/html/index.html";
    changelog = "https://github.com/gungraun/gungraun/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.OR (
      with lib.licenses;
      [
        mit
        asl20
      ]
    );
    maintainers = with lib.maintainers; [ chrjabs ];
  };
})
