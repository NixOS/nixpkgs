{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  rustPlatform,
  sonic-server,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "sonic-server";
  version = "1.4.9";

  src = fetchFromGitHub {
    owner = "valeriansaliou";
    repo = "sonic";
    rev = "refs/tags/v${version}";
    hash = "sha256-PTujR3ciLRvbpiqStNMx3W5fkUdW2dsGmCj/iFRTKJM=";
  };

  cargoHash = "sha256-bH9u38gvH6QEySQ3XFXEHBiSqKKtB+kjcZRLjx4Z6XM=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-faligned-allocation";

  postPatch = ''
    substituteInPlace src/main.rs \
      --replace-fail "./config.cfg" "$out/etc/sonic/config.cfg"
  '';

  postInstall = ''
    install -Dm444 -t $out/etc/sonic config.cfg
    install -Dm444 -t $out/lib/systemd/system debian/sonic.service

    substituteInPlace $out/lib/systemd/system/sonic.service \
      --replace-fail /usr/bin/sonic $out/bin/sonic \
      --replace-fail /etc/sonic.cfg $out/etc/sonic/config.cfg
  '';

  # Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  doCheck = false;

  passthru = {
    tests = {
      inherit (nixosTests) sonic-server;
      version = testers.testVersion {
        command = "sonic --version";
        package = sonic-server;
      };
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Fast, lightweight and schema-less search backend";
    homepage = "https://github.com/valeriansaliou/sonic";
    changelog = "https://github.com/valeriansaliou/sonic/releases/tag/v${version}";
    license = licenses.mpl20;
    platforms = platforms.unix;
    mainProgram = "sonic";
    maintainers = with maintainers; [
      pleshevskiy
      anthonyroussel
    ];
  };
}
