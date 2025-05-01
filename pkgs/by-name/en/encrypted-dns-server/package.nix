{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libsodium,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "encrypted-dns-server";
  version = "0.9.16";

  src = fetchFromGitHub {
    owner = "DNSCrypt";
    repo = "encrypted-dns-server";
    tag = version;
    hash = "sha256-llBMOqmxEcysoBsRg5s1uqCyR6+ilTgBI7BaeSDVoEw=";
  };

  cargoHash = "sha256-33XcfiktgDG34aamw8X3y0QkybVENUJxLhx47WZUpFc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libsodium ];

  env = {
    SODIUM_USE_PKG_CONFIG = true;
  };

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/encrypted-dns";
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/DNSCrypt/encrypted-dns-server/releases/tag/${version}";
    description = "An easy to install, high-performance, zero maintenance proxy to run an encrypted DNS server";
    homepage = "https://github.com/DNSCrypt/encrypted-dns-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ paepcke ];
    mainProgram = "encrypted-dns";
  };
}
