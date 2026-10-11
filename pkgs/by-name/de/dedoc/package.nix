{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dedoc";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "toiletbril";
    repo = "dedoc";
    rev = "1a889de59d642f6b82036b21d0f0f058d8acf9cc";
    hash = "sha256-NCXsinihB/86SgRzER7UfQ6ZbpmyuJowo7fi84PYGfE=";
  };

  cargoHash = "sha256-NrHWr+uaCxXBUy+DWO9XlAESchXuArLIbpvlua8rB+g=";

  meta = {
    description = "Terminal based viewer for DevDocs";
    homepage = "https://github.com/toiletbril/dedoc";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mmkaram ];
    mainProgram = "dedoc";
  };
})
