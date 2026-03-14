{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jsongrep";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "micahkepe";
    repo = "jsongrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TfWVW4OdxL7oiT0BzstOd2zn4xA9nYKy6pdkz3e7IuE=";
  };

  cargoHash = "sha256-XozdC+rokuLrn8AHbcHxKhBGZtkDbIHNp/sPPzbZPPw=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/micahkepe/jsongrep/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "JSONPath-inspired query language";
    longDescription = ''
      `jsongrep` is a command-line tool and Rust library for querying
      JSON documents using regular path expressions.
    '';
    homepage = "https://github.com/micahkepe/jsongrep";
    license = lib.licenses.mit;
    mainProgram = "jg";
    maintainers = with lib.maintainers; [ yiyu ];
  };
})
