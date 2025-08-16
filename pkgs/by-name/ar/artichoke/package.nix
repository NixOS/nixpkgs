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
  version = "0-unstable-2025-08-03";

  src = fetchFromGitHub {
    owner = "artichoke";
    repo = "artichoke";
    rev = "ff0b17820a5f64ea9e8b744cef4a9111df3ed252";
    hash = "sha256-0SUU/1gp7A0gjluc8ZyF9C4ZxAgNsM6jwuT3E8GxFQY=";
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
