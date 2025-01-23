{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-man";
  version = "unstable-2022-11-05";

  src = fetchFromGitHub {
    owner = "vv9k";
    repo = pname;
    rev = "b9537dfbb241d7456835ed7e9d27ab8c8184e5f6";
    hash = "sha256-ssAk60jnwYzAjseL26/3FaDv1vBAylgdE+vLhWZ8It4=";
  };

  cargoHash = "sha256-cR86eFhP9Swh+Ff8FNbAfWpWMkliOAyPwDQ6lRvU+nk=";

  meta = with lib; {
    description = "Generate manual pages from mdBooks";
    mainProgram = "mdbook-man";
    homepage = "https://github.com/vv9k/mdbook-man";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
