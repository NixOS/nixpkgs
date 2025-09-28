{
  lib,
  rustPlatform,
  fetchFromGitLab,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swaysome";
  version = "2.3.1";

  src = fetchFromGitLab {
    owner = "hyask";
    repo = "swaysome";
    tag = finalAttrs.version;
    hash = "sha256-/GJXZFa4HX98qJZw1CNM6PsP06EO8inIWDY6BWzQb8U=";
  };

  cargoHash = "sha256-+KjT5bako7l7lg2LW7Kxes7fIEnYQKUGGOMC56moO5g=";

  # failed to execute sway: Os { code: 2, kind: NotFound, message: "No such file or directory" }
  doCheck = false;

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  meta = {
    description = "Helper to make sway behave more like awesomewm";
    homepage = "https://gitlab.com/hyask/swaysome";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ esclear ];
    platforms = lib.platforms.linux;
    mainProgram = "swaysome";
  };
})
