{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "clock-tui";
  version = "0.5.0";
  src = fetchFromGitHub {
    owner = "race604";
    repo = "clock-tui";
    tag = "v${version}";
    hash = "sha256-sXfGm36WgL6h06cT9TowkaEaBB1roe4qP3OW2JJ3EwQ=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-JbuHwc8sGnwypp+8TTMgT47thZ9+KNhfMBirErxEpW8=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/xtask
    rm -f $out/bin/xtask

    installManPage assets/gen/tclock.1

    installShellCompletion --cmd tclock \
      --bash <(cat assets/gen/tclock.bash) \
      --fish <(cat assets/gen/tclock.fish) \
      --zsh <(cat assets/gen/_tclock)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Clock app in terminal written in Rust, supports local clock, timer and stopwatch";
    homepage = "https://github.com/race604/clock-tui";
    license = lib.licenses.mit;
    mainProgram = "tclock";
    maintainers = with lib.maintainers; [ Levizor ];
  };
}
