{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  pkg-config,
  libgit2,
  zlib,
  buildPackages,
  versionCheckHook,
  withClipboard ? true,
  withTrash ? !stdenv.hostPlatform.isDarwin,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "broot";
  version = "1.49.1";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "broot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zDy494qIoo4r+oCnrMvYSetmqsWCWfS5PAVlp8sU8Zk=";
  };

  cargoHash = "sha256-zHvfZAsEoCtdxtFP7yqrC9t49UIMji2qTm+I1bhu63A=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    libgit2
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    zlib
  ];

  buildFeatures = lib.optionals withTrash [ "trash" ] ++ lib.optionals withClipboard [ "clipboard" ];

  env.RUSTONIG_SYSTEM_LIBONIG = true;

  postPatch = ''
    # Fill the version stub in the man page. We can't fill the date
    # stub reproducibly.
    substitute man/page man/broot.1 \
      --replace-fail "#version" "${finalAttrs.version}"
  '';

  postInstall =
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      # Install shell function for bash.
      ${stdenv.hostPlatform.emulator buildPackages} $out/bin/broot --print-shell-function bash > br.bash
      install -Dm0444 -t $out/etc/profile.d br.bash

      # Install shell function for zsh.
      ${stdenv.hostPlatform.emulator buildPackages} $out/bin/broot --print-shell-function zsh > br.zsh
      install -Dm0444 br.zsh $out/share/zsh/site-functions/br

      # Install shell function for fish
      ${stdenv.hostPlatform.emulator buildPackages} $out/bin/broot --print-shell-function fish > br.fish
      install -Dm0444 -t $out/share/fish/vendor_functions.d br.fish

    ''
    + ''
      # install shell completion files
      OUT_DIR=$releaseDir/build/broot-*/out

      installShellCompletion --bash $OUT_DIR/{br,broot}.bash
      installShellCompletion --fish $OUT_DIR/{br,broot}.fish
      installShellCompletion --zsh $OUT_DIR/{_br,_broot}

      installManPage man/broot.1

      # Do not nag users about installing shell integration, since
      # it is impure.
      wrapProgram $out/bin/broot \
        --set BR_INSTALL no
    '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = with lib; {
    description = "Interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    changelog = "https://github.com/Canop/broot/releases/tag/v${finalAttrs.version}";
    maintainers = with maintainers; [ dywedir ];
    license = with licenses; [ mit ];
    mainProgram = "broot";
  };
})
