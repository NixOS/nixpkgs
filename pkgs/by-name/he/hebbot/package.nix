{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  runCommand,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hebbot";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "haecker-felix";
    repo = "hebbot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-log2h3mWSBQu1zjki6mMW7Lcph2dht0ksVkdacum0Jc=";
  };

  cargoHash = "sha256-cfHD66uf6zIeml69VRGy9bjbdS3PkOfNBdTam5UCzso=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    sqlite
  ];

  env.OPENSSL_NO_VENDOR = 1;

  passthru.tests = {
    startup = runCommand "hebbot-startup-test" { } ''
      unset BOT_PASSWORD
      export CONFIG_PATH="$TMPDIR/missing-config.toml"
      export STORE_PATH="$TMPDIR/store.json"

      status=0
      ${lib.getExe finalAttrs.finalPackage} > missing-config.log 2>&1 || status=$?
      test "$status" -eq 101
      grep -F "Unable to open file: $CONFIG_PATH (CONFIG_PATH)" missing-config.log

      export CONFIG_PATH="${finalAttrs.src}/doc/example_config/config.toml"
      status=0
      ${lib.getExe finalAttrs.finalPackage} > missing-password.log 2>&1 || status=$?
      test "$status" -eq 101
      grep -F "BOT_PASSWORD env variable not specified" missing-password.log

      touch "$out"
    '';
  };

  meta = {
    description = "Matrix bot which can generate \"This Week in X\" like blog posts";
    homepage = "https://github.com/haecker-felix/hebbot";
    changelog = "https://github.com/haecker-felix/hebbot/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ agpl3Only ];
    mainProgram = "hebbot";
    maintainers = with lib.maintainers; [ a-kenji ];
  };
})
