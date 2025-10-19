{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  icu,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "msedit";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "edit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G5U5ervW1NAQY/fnwOWv1FNuKcP+HYcAW5w87XHqgA8=";
  };

  cargoHash = "sha256-ceAaaR+N03Dq2MHYel4sHDbbYUOr/ZrtwqJwhaUbC2o=";
  # Requires nightly features
  env.RUSTC_BOOTSTRAP = 1;

  # Without -headerpad, the following error occurs on x86_64-darwin
  # error: install_name_tool: changing install names or rpaths can't be redone for: ... because larger updated load commands do not fit (the program must be relinked, and you may need to use -headerpad or -headerpad_max_install_names)
  NIX_LDFLAGS = lib.optionals (with stdenv.hostPlatform; isDarwin && isx86_64) [
    "-headerpad_max_install_names"
  ];

  buildInputs = [
    icu
  ];

  # https://github.com/microsoft/edit/blob/f8bea2be191d00baa2a4551817541ea3f8c5b03e/src/icu.rs#L834
  # Required for Ctrl+F searching to work
  postFixup =
    let
      rpathAppend = lib.makeLibraryPath [ icu ];
    in
    lib.optionalString stdenv.hostPlatform.isElf ''
      patchelf $out/bin/edit \
        --add-rpath ${rpathAppend}
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      ${stdenv.cc.targetPrefix}install_name_tool -add_rpath ${rpathAppend} $out/bin/edit
    '';

  # Disabled for now, microsoft/edit#194
  doInstallCheck = false;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/edit";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple editor for simple needs";
    longDescription = ''
      This editor pays homage to the classic MS-DOS Editor,
      but with a modern interface and input controls similar to VS Code.
      The goal is to provide an accessible editor that even users largely
      unfamiliar with terminals can easily use.
    '';
    mainProgram = "edit";
    homepage = "https://github.com/microsoft/edit";
    changelog = "https://github.com/microsoft/edit/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RossSmyth ];
    platforms = lib.platforms.all;
  };
})
