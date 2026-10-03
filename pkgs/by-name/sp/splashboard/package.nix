{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "splashboard";
  version = "1.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "unhappychoice";
    repo = "splashboard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5qroM5wZtMmcFFGo6laCXCpT4jYuaWNsCWbGzkbYHz8=";
  };

  cargoHash = "sha256-CbJ+Nsifk7AB0BSdDw1k4qN4w0uPTDzQ9M0+gwDbp20=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = {
    description = "A customizable terminal splash screen with plugin-based data sources";
    homepage = "https://github.com/unhappychoice/splashboard";
    changelog = "https://github.com/unhappychoice/splashboard/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ gwg313 ];
    mainProgram = "splashboard";
  };
})
