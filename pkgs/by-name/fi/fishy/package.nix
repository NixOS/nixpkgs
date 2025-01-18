{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "fishy";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "p2panda";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-nRkP53v9+VzqHKTsHs+cBeLjh3yASFE18sSEY02NR1s=";
  };

  cargoHash = "sha256-4CzchWX7pd3IOTGMZj24zgJVelaYKOnKyCxGpwsCTMI=";

  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = {
    description = "Create, manage and deploy p2panda schemas";
    homepage = "https://github.com/p2panda/fishy";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ confusedalex ];
    mainProgram = "fishy";
  };
}
