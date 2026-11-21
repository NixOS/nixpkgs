{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  sqlite,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rainfrog";
  version = "0.4.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "achristmascarl";
    repo = "rainfrog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IYJIs9EBkIz8lSBeClSOGCOpxEthlzP3bQZsXjHm70k=";
  };

  cargoHash = "sha256-/VFeLCC80ipTGuXcR0kihukCxtAt6ksLjnoZPwjy+w4=";

  env.LIBGIT2_NO_VENDOR = 1;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    sqlite
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/achristmascarl/rainfrog/releases/tag/v${finalAttrs.version}";
    description = "Database management TUI for postgres";
    homepage = "https://github.com/achristmascarl/rainfrog";
    license = lib.licenses.mit;
    mainProgram = "rainfrog";
    maintainers = with lib.maintainers; [ patka ];
  };
})
