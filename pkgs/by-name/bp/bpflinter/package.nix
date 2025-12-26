{
  lib,
  fetchFromGitHub,
  rustPlatform,
  fetchpatch,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bpflinter";
  version = "0.3.0";
  cargoBuildFlags = [
    "-p"
    "bpflinter"
  ];
  src = fetchFromGitHub {
    owner = "d-e-s-o";
    repo = "bpflint";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9UC13hHfOm9/bZv0eLTLO1ncf97ST9EUSNqmN12JJ1Q=";
  };

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  cargoPatches = [
    (fetchpatch {
      name = "add_cargo_lock.patch";
      url = "https://github.com/fzakaria/bpflint/commit/99e4c3389709c534e09ecbb0cd9bf87b594fb735.patch";
      hash = "sha256-dwDdxzICSYTUspJJQwoGCjyhOPX0CLwyZZyd7AondGg=";
    })
  ];

  cargoHash = "sha256-OChF679ZzbzgM6gj4PInQxk/hQi4dxYxHYGLlKwh2Ko=";

  meta = {
    mainProgram = "bpflinter";
    description = "Linting functionality for BPF C programs.";
    homepage = "https://github.com/d-e-s-o/bpflint";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fzakaria ];
  };
})
