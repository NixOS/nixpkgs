{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "mdbook-man";
  version = "0-unstable-2022-11-05";

  src = fetchFromGitHub {
    owner = "vv9k";
    repo = "mdbook-man";
    rev = "b9537dfbb241d7456835ed7e9d27ab8c8184e5f6";
    hash = "sha256-ssAk60jnwYzAjseL26/3FaDv1vBAylgdE+vLhWZ8It4=";
  };

  cargoHash = "sha256-+CD7+pYAoKRmkMZPpEru6lug9sBakrL0rLXs78e3tqk=";

  meta = with lib; {
    description = "Generate manual pages from mdBooks";
    mainProgram = "mdbook-man";
    homepage = "https://github.com/vv9k/mdbook-man";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
