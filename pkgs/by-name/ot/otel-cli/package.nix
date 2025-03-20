{
  lib,
  buildGoModule,
  fetchFromGitHub,
  getent,
  coreutils,
  nix-update-script,
  stdenv,
}:

buildGoModule rec {
  pname = "otel-cli";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "equinix-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JYi9CbP4mUhX0zNjhi6QlBzLKcj2zdPwlyBSIYKp6vk=";
  };

  vendorHash = "sha256-fWQz7ZrU8gulhpOHSN8Prn4EMC0KXy942FZD/PMsLxc=";

  preCheck =
    ''
      ln -s $GOPATH/bin/otel-cli .
    ''
    + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      substituteInPlace main_test.go \
        --replace-fail 'const minimumPath = `/bin:/usr/bin`' 'const minimumPath = `${
          lib.makeBinPath [
            getent
            coreutils
          ]
        }`'
    '';

  patches = [ ./patches/bin-echo-patch.patch ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/equinix-labs/otel-cli";
    description = "Command-line tool for sending OpenTelemetry traces";
    changelog = "https://github.com/equinix-labs/otel-cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [
      emattiza
      urandom
    ];
    mainProgram = "otel-cli";
  };
}
