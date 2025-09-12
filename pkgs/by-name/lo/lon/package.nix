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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "nikstur";
    repo = "lon";
    tag = version;
    hash = "sha256-bxu83mbdfAeDZYOnjZQYyjTs5WgZS8o6Q2irlzgbYs0=";
  };

  sourceRoot = "source/rust/lon";

  cargoHash = "sha256-x+qxn0s64fPJpTG/d0PgzAdzMXegYdnsC1FFFuBpsaI=";

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
