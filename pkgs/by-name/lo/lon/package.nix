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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "nikstur";
    repo = "lon";
    tag = version;
    hash = "sha256-+hCqAtu9uo9BndZogXUIMMoL1pXmwyec5edj6gg82GM=";
  };

  sourceRoot = "source/rust/lon";

  useFetchCargoVendor = true;
  cargoHash = "sha256-i+DAVtXAYQ254Y7jechjOcwe3nT/0O4AzxBH5QkK9aM=";

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
