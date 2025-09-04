{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  makeWrapper,
  pciutils,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyfetch";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "hykilpikonna";
    repo = "hyfetch";
    tag = finalAttrs.version;
    hash = "sha256-Y9v2vrpTPlsgFRoo33NDVoyQSgUD/stKQLJXzUxFesA=";
  };

  cargoHash = "sha256-auOeH/1KtxS7a1APOtCMwNTdEQ976BL/jEKj2ADaakQ=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  # NOTE: The HyFetch project maintains an updated version of neofetch renamed
  # to "neowofetch" which is included in this package. However, the man page
  # included is still named "neofetch", so to prevent conflicts and confusion
  # we rename the file to "neowofetch" before installing it:
  postInstall = ''
    mv ./docs/neofetch.1 ./docs/neowofetch.1
    installManPage ./docs/hyfetch.1 ./docs/neowofetch.1

    install -m 755 neofetch $out/bin/neowofetch
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd hyfetch \
      --bash <($out/bin/hyfetch --bpaf-complete-style-bash) \
      --fish <($out/bin/hyfetch --bpaf-complete-style-fish) \
      --zsh <($out/bin/hyfetch --bpaf-complete-style-zsh)
  '';

  postFixup = ''
    wrapProgram $out/bin/neowofetch \
      --prefix PATH : ${lib.makeBinPath [ pciutils ]}
  '';

  outputs = [
    "out"
    "man"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "PATH" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Neofetch with LGBTQ+ pride flags";
    longDescription = ''
      HyFetch is a command-line system information tool fork of neofetch.
      HyFetch displays information about your system next to your OS logo
      in ASCII representation. The ASCII representation is then colored in
      the pattern of the pride flag of your choice. The main purpose of
      HyFetch is to be used in screenshots to show other users what
      operating system or distribution you are running, what theme or
      icon set you are using, etc.
    '';
    homepage = "https://github.com/hykilpikonna/hyfetch";
    changelog = "https://github.com/hykilpikonna/hyfetch/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "hyfetch";
    maintainers = with lib.maintainers; [
      yisuidenghua
      isabelroses
      nullcube
      defelo
    ];
  };
})
