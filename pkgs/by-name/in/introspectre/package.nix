{
  lib,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  rustPlatform,
  sqlite,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "introspectre";
  version = "1.13.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "m3m0rydmp";
    repo = "Introspectre";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3wiVw51vHK1hrk6UUFIrUP7l3UkvFe1XSxVEvKZT9Ro=";
  };

  cargoHash = "sha256-FzNm9/iC7DTmMvGiV/SEWc2VXc0X3y9SYRhNWRd+NNU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ sqlite ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
  };

  checkFlags = [
    "--skip=traffic::tests::session_headers_match_target_host_and_pick_auth_cookies"
  ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to scan graphql endpoint and find some vulnerabilities";
    homepage = "https://github.com/m3m0rydmp/Introspectre";
    changelog = "https://github.com/m3m0rydmp/Introspectre/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "introspectre";
  };
})
