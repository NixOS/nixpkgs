{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "ferret";
  version = "0.18.1";

  vendorHash = "sha256-F8NpMcIQUOlhjGB/Fc7mVW9HNn5O0AC26Onu9pGixz4=";

  src = fetchFromGitHub {
    owner = "MontFerret";
    repo = "ferret";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LqXP4h9V4rPgzPt6UQ3XZ0/RFFuGvSdTu3UIDeXKcT4=";
  };

  checkFlags = [
    # Uses an HTTP request to validate that a URL returns a response.
    # No networking in build sandbox.
    # https://github.com/MontFerret/ferret/blob/v0.18.1/pkg/stdlib/html/document_exists.go#L17-L74
    "-skip=TestDocumentExists"
  ];

  env.CGO_ENABLED = 0;

  postInstall = ''
    mv $out/bin/e2e $out/bin/ferret
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Declarative web scraping system aiming to simplify data extraction from the web";
    homepage = "https://www.montferret.dev/";
    downloadPage = "https://github.com/MontFerret/ferret/releases/v${finalAttrs.version}";
    changelog = "https://github.com/MontFerret/ferret/blob/v${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ kpbaks ];
    license = lib.licenses.asl20;
    mainProgram = "ferret";
  };
})
