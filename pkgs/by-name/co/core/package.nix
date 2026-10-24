{
  lib,
  rustPlatform,
  fetchFromGitea,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "core";
  version = "0-unstable-2026-10-16";
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "core-lang";
    repo = "core";
    rev = "2a59f228929191ed4a848a8de03dadbca45c85cb";
    hash = "sha256-oPsE5dsKQmi8dm5GLQo9pouI0ZoziB6NBlBh4xkbhhQ=";
  };

  cargoHash = "sha256-3uxefbJA6IlRK8p28iR8jFSc/MVbyscywgmDINRmJio=";

  # Static library is only useful with the disabled `aot` feature
  postInstall = ''
    rm -r "$out/lib"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Compiler, runtime and standard library of Core";
    longDescription = ''
      Core is a modern programming language that uses a minimal set of
      orthogonal building blocks to ensure simplicity, readability,
      modifiability and stability.
    '';
    homepage = "https://core-lang.dev";
    changelog = "https://core-lang.dev/changes.html";
    license = with lib.licenses; [
      eupl12
      mit
    ];
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "core";
    # Arm64 backend and macOS support do not compile
    # https://codeberg.org/core-lang/core/issues/111
    platforms = [ "x86_64-linux" ];
  };
}
