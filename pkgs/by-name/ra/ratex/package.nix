{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ratex";
  version = "0.1.16";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "erweixin";
    repo = "RaTeX";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iSN29xs40YwRKqIYzhW4VGHbp43Izri0L4qMxPjhtQk=";
  };

  cargoHash = "sha256-Od8mvBK7eeaar23xz5rdBkZEpYVNyJlLlAns1TuLhKM=";

  cargoBuildFlags = [
    "--package=ratex-svg"
    "--package=ratex-pdf"
    "--package=ratex-render"
  ];

  cargoTestFlags = finalAttrs.cargoBuildFlags;

  buildFeatures = [
    "ratex-svg/cli"
    "ratex-svg/embed-fonts"
    "ratex-pdf/cli"
    "ratex-pdf/embed-fonts"
    "ratex-render/embed-fonts"
  ];

  # Upstream binary names are too generic for a shared PATH
  postInstall = ''
    mv $out/bin/render $out/bin/ratex-render
    mv $out/bin/render-svg $out/bin/ratex-svg
    mv $out/bin/render-pdf $out/bin/ratex-pdf
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    echo '\frac{a}{b}' | $out/bin/ratex-svg --stdout | grep -q '<svg'
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "KaTeX-compatible math renderer producing SVG, PDF, and PNG from LaTeX formulas";
    homepage = "https://github.com/erweixin/RaTeX";
    changelog = "https://github.com/erweixin/RaTeX/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      ofl
    ];
    maintainers = with lib.maintainers; [ psionic-k ];
    mainProgram = "ratex-svg";
  };
})
