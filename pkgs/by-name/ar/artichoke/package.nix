{
  lib,
  rustPlatform,
  fetchFromGitHub,
  llvmPackages,
  _experimental-update-script-combinators,
  unstableGitUpdater,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "artichoke";
  version = "0-unstable-2025-11-02";

  src = fetchFromGitHub {
    owner = "artichoke";
    repo = "artichoke";
    rev = "dbeb76f881d1729a08a3e970cf57c205dcbfc03a";
    hash = "sha256-XFNxc3vCS5BrzFtBBiD0bf/SOO/+nk9nY8NQJu2XynE=";
  };

  cargoHash = "sha256-Qz6vlh/LiB+07KRfSiLAgtW+Zg9KUj3XRQCPQxjUz3A=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    stdout="$("$out/bin/artichoke" -e 'puts "Hello World!"')"
    [[ "$stdout" == 'Hello World!' ]]

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (unstableGitUpdater { })
      (nix-update-script {
        # Updating `cargoHash`
        extraArgs = [ "--version=skip" ];
      })
    ];
  };

  meta = {
    description = "Ruby implementation written in Rust and Ruby";
    homepage = "https://www.artichokeruby.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "artichoke";
    platforms = with lib.platforms; unix ++ windows;
  };
}
