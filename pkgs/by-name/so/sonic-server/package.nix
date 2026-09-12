{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "sonic-server";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "valeriansaliou";
    repo = "sonic";
    tag = "v${version}";
    hash = "sha256-h7esGUAhznJEktELNHNRBxUKi9nB6pwJKjehTz+q3Zo=";
  };

  cargoHash = "sha256-AKzLAXzZw/Vi7UOJhrvuCaD9ES8YG5Ooa3+VkkPPEyQ=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  postPatch = ''
    substituteInPlace server/src/main.rs \
      --replace-fail "./config.cfg" "$out/etc/sonic/config.cfg"
  '';

  postInstall = ''
    install -Dm444 -t $out/etc/sonic config.cfg
    install -Dm444 -t $out/lib/systemd/system packaging/debian/sonic.service

    substituteInPlace $out/lib/systemd/system/sonic.service \
      --replace-fail /usr/bin/sonic $out/bin/sonic \
      --replace-fail /etc/sonic.cfg $out/etc/sonic/config.cfg
  '';

  # Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests.sonic-server = nixosTests.sonic-server;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast, lightweight and schema-less search backend";
    homepage = "https://github.com/valeriansaliou/sonic";
    changelog = "https://github.com/valeriansaliou/sonic/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    mainProgram = "sonic";
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
}
