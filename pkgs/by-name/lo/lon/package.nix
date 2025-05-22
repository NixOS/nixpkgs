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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "nikstur";
    repo = "lon";
    tag = version;
    hash = "sha256-/7RelKn3pzC8n+b2OV1pcUEaWeEoH4qC2TvAWwni5AA=";
  };

  sourceRoot = "source/rust/lon";

  useFetchCargoVendor = true;
  cargoHash = "sha256-2/lHRv3bD0hX/JVSucsA3G5gM9NMgRrBf21JtEvzu64=";

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
