{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdsh";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "mdsh";
    rev = "v${version}";
    hash = "sha256-vN8nFhbZgJIhFuFET9IOmdxT7uBKq/9X+TO9lZsDw6g=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kNe0WzW/9kcocRHR1FMKKIMnyZceqzShWQ9Cf7mAx0c=";

  meta = with lib; {
    description = "Markdown shell pre-processor";
    homepage = "https://github.com/zimbatm/mdsh";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zimbatm ];
    mainProgram = "mdsh";
  };
}
