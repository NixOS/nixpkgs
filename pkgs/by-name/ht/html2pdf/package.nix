{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  chromium,
  withChromium ? (lib.meta.availableOn stdenv.hostPlatform chromium),
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "html2pdf";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "ilaborie";
    repo = "html2pdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JtBgM95BvCJQwF89+PXkCEdrFDlD+hdceTtI5t6KnUQ=";
  };

  cargoHash = "sha256-65do3FDEpGeNX/u9KS+F5yigwBfgVNUBhZImjbWFydU=";

  # Avoiding "rustfmt not found" error in auto_generate_cdp.
  # ref: https://github.com/mdrokz/auto_generate_cdp/pull/8
  env.DO_NOT_FORMAT = "true";

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = lib.optionalString withChromium (
    let
      runtimeInputs = [
        chromium
      ];
    in
    ''
      wrapProgram "$out/bin/html2pdf" --prefix PATH : '${lib.makeBinPath runtimeInputs}'
    ''
  );

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool to convert local HTML files to PDF";
    homepage = "https://github.com/ilaborie/html2pdf";
    changelog = "https://github.com/ilaborie/html2pdf/blob/v${finalAttrs.version}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        mit
        asl20
      ];
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "html2pdf";
  };
})
