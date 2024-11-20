{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  pass,
}:

rustPlatform.buildRustPackage {
  pname = "passepartui";
  version = "unstable-2024-11-20";

  src = fetchFromGitHub {
    owner = "kardwen";
    repo = "passepartui";
    rev = "2819bad8f5376d3e084672da48ff4429dd53a456";
    sha256 = "sha256-VM174bmEXdjC8nqZbq0t50l3AWWjgYd5huYo7SuxEPY=";
  };

  cargoHash = "sha256-ce/QwmVEdqh3qoWEtVD+xrbf+XdCOVT6U9pjA0IoLN8=";

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [ pass ];

  meta = with lib; {
    description = "A TUI for pass";
    homepage = "https://github.com/kardwen/passepartui";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      matthiasbeyer
    ];
    mainProgram = "passepartui";
  };
}
