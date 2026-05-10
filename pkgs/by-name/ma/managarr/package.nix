{
  lib,
  fetchFromGitHub,
  rustPlatform,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "managarr";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "Dark-Alex-17";
    repo = "managarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bKW67cpLbnBxF5gbpwfCNe2QkxKYvooWEM3yKrbj7Q8=";
  };

  cargoHash = "sha256-CDhFj7lP65wlLkSWGcQ8YBK4umSyQsBGF/Sn85gy5hE=";

  nativeBuildInputs = [ perl ];

  meta = {
    description = "TUI and CLI to manage your Servarrs";
    homepage = "https://github.com/Dark-Alex-17/managarr";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.IncredibleLaser
      lib.maintainers.darkalex
      lib.maintainers.nindouja
    ];
    mainProgram = "managarr";
  };
})
