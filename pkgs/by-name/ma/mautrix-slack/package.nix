{
  lib,
  buildGoModule,
  fetchFromGitHub,
  olm,
  nix-update-script,
  testers,
  mautrix-slack,
  # This option enables the use of an experimental pure-Go implementation of
  # the Olm protocol instead of libolm for end-to-end encryption. Using goolm
  # is not recommended by the mautrix developers, but they are interested in
  # people trying it out in non-production-critical environments and reporting
  # any issues they run into.
  withGoolm ? false,
}:
let
  version = "0.1.3";
in
buildGoModule {
  pname = "mautrix-slack";
  inherit version;

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "slack";
    rev = "v${version}";
    hash = "sha256-LmGcS2ib/6ZU2w6XlT//HsTjY2NP0Obx+ybsQkUhwVk=";
  };

  vendorHash = "sha256-zb2/MN/kmR89M23sGO6hL047tE7aS66h08rUBRkcQe8=";

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = mautrix-slack;
    };
  };

  meta = {
    description = "Matrix-Slack puppeting bridge";
    homepage = "https://github.com/mautrix/slack";
    changelog = "https://github.com/mautrix/slack/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ BonusPlay ];
    mainProgram = "mautrix-slack";
  };
}
