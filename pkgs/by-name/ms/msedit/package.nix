{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  desktopToDarwinBundle,
  copyDesktopItems,
  iconConvTools,
  installShellFiles,
  nix-update-script,
  icu,
}:
let
  # Needs a hardcoded SONAME for some reason.
  icuMaj = lib.versions.major icu.version;

  # The library path needed to run properly
  rpathAppend = lib.makeLibraryPath [ icu ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "msedit";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "edit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9HoK5i0IimujfTQxDplBNJRO7qmD/S+SnLLnR95RHiQ=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-r7AR6Mf13UUeooPV5/8gyp7HvmOeSaOJNotWWqU10SQ=";

  # Requires nightly features
  env = {
    EDIT_CFG_ICUI18N_SONAME = "libicui18n.so.${icuMaj}";
    EDIT_CFG_ICUUC_SONAME = "libicuuc.so.${icuMaj}";
    EDIT_CFG_ICU_RENAMING_VERSION = icuMaj;

    # For checkPhase to work
    LD_LIBRARY_PATH = rpathAppend;

    # Without -headerpad, the following error occurs on x86_64-darwin
    # error: install_name_tool: changing install names or rpaths can't be redone for: ... because larger updated load commands do not fit (the program must be relinked, and you may need to use -headerpad or -headerpad_max_install_names)
    NIX_LDFLAGS = toString (
      lib.optionals (with stdenv.hostPlatform; isDarwin && isx86_64) [
        "-headerpad_max_install_names"
      ]
    );
  };

  nativeBuildInputs = [
    copyDesktopItems
    iconConvTools
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  buildInputs = [
    icu
  ];

  desktopItems = [
    "assets/com.microsoft.edit.desktop"
  ];

  # https://github.com/microsoft/edit/blob/f8bea2be191d00baa2a4551817541ea3f8c5b03e/src/icu.rs#L834
  # Required for Ctrl+F searching to work
  postFixup = ''
    icoFileToHiColorTheme assets/edit.ico edit "$out"
    install -Dm444 assets/edit.svg "$out/share/icons/hicolor/scalable/apps/edit.svg"

    installManPage assets/manpage/edit.1
  ''
  + lib.optionalString stdenv.hostPlatform.isElf ''
    patchelf $out/bin/edit \
      --add-rpath ${rpathAppend}
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    ${stdenv.cc.targetPrefix}install_name_tool -add_rpath ${rpathAppend} $out/bin/edit
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/edit";

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
