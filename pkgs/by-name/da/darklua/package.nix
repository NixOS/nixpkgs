{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "darklua";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "seaofvoices";
    repo = "darklua";
    rev = "v${version}";
    hash = "sha256-Ql3BHItFvfc2C3+/M7gxFJwValxNaBVVftm6+T5N4S8=";
  };

  cargoHash = "sha256-eJObrfhZMfgWUAqeTgOSic4u5fG5Eopqmvojiq+b54o=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = with lib; {
    description = "Command line tool that transforms Lua code";
    mainProgram = "darklua";
    homepage = "https://darklua.com";
    changelog = "https://github.com/seaofvoices/darklua/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ tomodachi94 ];
  };
}
