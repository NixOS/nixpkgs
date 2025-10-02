{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "bootspec";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "bootspec";
    rev = "v${version}";
    hash = "sha256-WDEaTxj5iT8tvasd6gnMhRgNoEdDi9Wi4ke8sVtNpt8=";
  };

  cargoHash = "sha256-ZJKoL1vYfAG1rpCcE1jRm7Yj2dhooJ6iQ91c6EGF83E=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Implementation of RFC-0125's datatype and synthesis tooling";
    homepage = "https://github.com/DeterminateSystems/bootspec";
    license = licenses.mit;
    teams = [ teams.determinatesystems ];
    platforms = platforms.unix;
  };
}
