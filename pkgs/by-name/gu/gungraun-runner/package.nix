{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  valgrind-light,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gungraun-runner";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "gungraun";
    repo = "gungraun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8AuC5AqsiqXFomIEVPbRh1aYf/HQRg7oEVGiH6gdHFg=";
  };

  cargoHash = "sha256-ERBYOFMkd+jy6u/mpSCvm0GMOYPYRO6ZwH9iVhttJng=";

  cargoBuildFlags = [
    "--package"
    "gungraun-runner"
  ];

  cargoTestFlags = [
    "--package"
    "gungraun-runner"
  ];

  nativeBuildInputs = [
    makeWrapper
    valgrind-light
  ];

  # Suppress warning about preferring GUNGRAUN_LOG over RUST_LOG
  preCheck = ''
    unset RUST_LOG
  '';

  postFixup = ''
    wrapProgram $out/bin/gungraun-runner \
      --prefix PATH : ${lib.makeBinPath [ valgrind-light ]}
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Binary runner for Gungraun, a high-precision, one-shot and consistent benchmarking framework/harness for Rust";
    homepage = "https://github.com/gungraun/gungraun";
    changelog = "https://github.com/gungraun/gungraun/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ cathalmullan ];
    mainProgram = "gungraun-runner";
    platforms = valgrind-light.meta.platforms;
  };
})
