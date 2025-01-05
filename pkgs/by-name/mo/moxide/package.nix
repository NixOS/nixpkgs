{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "moxide";
  version = "0.1.0";

  cargoHash = "sha256-MqJ3lxnzvvmNXEMgx0su8vRDXAZbNtPuuphNzjeMN+w=";
  src = fetchFromGitHub {
    owner = "dlurak";
    repo = "moxide";
    tag = "v${version}";
    hash = "sha256-XYEcMaHqu84aKIcV0pQZXl4sIeH9BkRGA2gcwZveXCU=";
  };

  meta = {
    description = "Tmux session manager with a modular configuration";
    mainProgram = "moxide";
    homepage = "https://github.com/dlurak/moxide";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dlurak ];
  };
}
