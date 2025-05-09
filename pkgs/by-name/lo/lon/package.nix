{
  rustPlatform,
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-prefetch-git,
  gitMinimal,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "lon";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "nikstur";
    repo = "lon";
    tag = version;
    hash = "sha256-tF9nzTIX0pU/N+h6i7ftn8RhwVB1o3O9+g+sziJvGwc=";
  };

  sourceRoot = "source/rust/lon";

  useFetchCargoVendor = true;
  cargoHash = "sha256-Aa8Rkny5hBfQpGcZYJrbzU00ExJPTfhQzKDbHAt8rXE=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/lon --prefix PATH : ${
      lib.makeBinPath [
        nix-prefetch-git
        gitMinimal
      ]
    }
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Lock & update Nix dependencies";
    homepage = "https://github.com/nikstur/lon";
    changelog = "https://github.com/nikstur/lon/blob/${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      ma27
      nikstur
    ];
    license = lib.licenses.mit;
    mainProgram = "lon";
  };
}
