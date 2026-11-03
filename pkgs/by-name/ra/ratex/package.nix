{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ratex";
  # Upstream has not yet shipped a tag since adding Cargo.lock to its src.
  version = "0.1.15-unstable-2026-10-31";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "erweixin";
    repo = "RaTeX";
    rev = "f0ef2cf7c15d85c41743d4bd2df19759cf0dfee3";
    hash = "sha256-r23xqB+NKTY/RynJoGYA8Tyf5myhefujKZJovsBzSbk=";
  };

  cargoHash = "sha256-Zdhk7Y7xLzmc0t0F5AUm5NbA4OUaAZBzaEwcGgSPgZA=";

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
