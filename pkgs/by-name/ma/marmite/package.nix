{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "marmite";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "rochacbruno";
    repo = "marmite";
    tag = version;
    hash = "sha256-EPoBNfKkefOe82jXE3c6Y59iP2N6lLIbRvu65fcIcLg=";
  };

  cargoHash = "sha256-ec9X4cR3sI1LW9680LB2dPeXQ6fmO/2fmsJmc7s/nxI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = {
    description = "Static Site Generator for Blogs";
    homepage = "https://github.com/rochacbruno/marmite";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "marmite";
  };
}
