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
  version = "0-unstable-2025-08-18";

  src = fetchFromGitHub {
    owner = "artichoke";
    repo = "artichoke";
    rev = "2dc4c45dc3f925b9aaefc44c33e75dec7586b6ad";
    hash = "sha256-miZWT1oMyKJLA+6zO881cy4kJrkkmOpfm/l7Su/ECUw=";
  };

  cargoHash = "sha256-JD+qt0pu5wxIuLa3Bd9eadQFE7dyKzqxsAKPebG7+Zg=";

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
