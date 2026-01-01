{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  zig,
<<<<<<< HEAD
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
=======
}:

rustPlatform.buildRustPackage rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "cargo-zigbuild";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "messense";
    repo = "cargo-zigbuild";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
=======
    rev = "v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-xJiYtVrvWEBsyTbcHKsbnTpbcTryX+ZP/OjD7GP6gQU=";
  };

  cargoHash = "sha256-oByCrAUkDq+UxoAiKjKX86ETHW3yIs8oYVCgwgr8ngA=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-zigbuild \
      --prefix PATH : ${zig}/bin
  '';

<<<<<<< HEAD
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Tool to compile Cargo projects with zig as the linker";
    mainProgram = "cargo-zigbuild";
    homepage = "https://github.com/messense/cargo-zigbuild";
<<<<<<< HEAD
    changelog = "https://github.com/messense/cargo-zigbuild/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
=======
    changelog = "https://github.com/messense/cargo-zigbuild/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
