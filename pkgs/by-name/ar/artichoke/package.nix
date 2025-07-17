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
  version = "0-unstable-2025-06-18";

  src = fetchFromGitHub {
    owner = "artichoke";
    repo = "artichoke";
    rev = "94921a493f680381c83465e5c50e5d494a7048f6";
    hash = "sha256-JdCGCvs7GK/I3yyIl4n9OGtN9VwzmwdDdglwbTHfx0Y=";
  };

  cargoHash = "sha256-a43awTdhOlu+KO3B6XQ7Vdv4NbZ3iffq4rpmBBgUcZ8=";

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
