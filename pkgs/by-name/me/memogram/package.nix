{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:
buildGo127Module (finalAttrs: {
  pname = "memogram";
  version = "26.10.0";

  src = fetchFromGitHub {
    owner = "usememos";
    repo = "telegram-integration";
    tag = finalAttrs.version;
    hash = "sha256-OHJnyQZc9KjDe2Y7ljALDCypbzHcupxT3f3SUajQIYk=";
  };

  vendorHash = "sha256-eQ2vAUWFPoe6YX+gZ0cs0CJP88b3IQmSZKMZ6A58GWk=";

  nativeBuildInputs = [ gitMinimal ];

  subPackages = [ "bin/memogram" ];

  # Mirrors the default checkPhase, but tests every package rather than only
  # subPackages: the unit and release-script tests live in the other packages.
  checkPhase = ''
    runHook preCheck
    # As in the default checkPhase, in case tests reference test assets
    export GOFLAGS=''${GOFLAGS//-trimpath/}
    go test ./...
    runHook postCheck
  '';

  # memogram rejects builds whose version does not follow its YY.MM.N scheme,
  # and a Go build without VCS metadata cannot derive the version itself.
  ldflags = [ "-X github.com/usememos/memogram/internal/version.Version=${finalAttrs.version}" ];

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Easy to use integration service for syncing messages and images from a Telegram bot into your Memos";
    homepage = "https://github.com/usememos/telegram-integration";
    changelog = "https://github.com/usememos/telegram-integration/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ merrkry ];
    mainProgram = "memogram";
    platforms = lib.platforms.linux;
  };
})
