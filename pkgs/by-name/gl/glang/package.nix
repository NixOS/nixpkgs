{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "glang";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "george-language";
    repo = "glang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M7A3fydw++etKqgETIZ41t63LkiTz09Lsyy7aiwcW/E=";
  };

  cargoHash = "sha256-8NiJOTj6a/ZbT2LVy+GQ0XhTCodKHoTdHWSXZ9bNfY8=";

  __structuredAttrs = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "HOME" ];
  # On every start glang creates ~/.glang and downloads glang-lib unless its
  # registry already lists it.  Provide a writable HOME with a stub entry so
  # the check works offline and in the Darwin sandbox.
  preVersionCheck = ''
    export HOME=$(mktemp -d)
    mkdir -p "$HOME/.glang"
    echo '{"packages": {"lib": {}}}' > "$HOME/.glang/packages.json"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dog-themed interpreted language for beginners";
    homepage = "https://github.com/george-language/glang";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "glang";
  };
})
