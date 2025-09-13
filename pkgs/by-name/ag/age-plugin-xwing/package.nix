{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "age-plugin-xwing";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Rixxc";
    repo = "age-plugin-xwing";
    tag = "v${version}";
    hash = "sha256-jjIArFXbFjhemBDbJdphhWfqID/UGmOxBUeKTIT+2jU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-54ZYd/wNHpm38KuMxUStXUiaz94pdqGEaM381zpsulg=";

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "X-Wing plugin for age";
    homepage = "https://github.com/Rixxc/age-plugin-xwing";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ rixxc ];
    mainProgram = "age-plugin-xwing";
  };
}
