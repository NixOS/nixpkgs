{
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  fzy,
  lib,
  nix-index-unwrapped,
  nix,
  rustPlatform,
  versionCheckHook,
  buildPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "comma";
  version = "2.4.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "comma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XZB0zx4wyNzy0LggAmh2gT2aEWAqVI9NljRoOkeK0c8=";
  };

  cargoHash = "sha256-lY5HwWZm9X0xusLcC6MciAgSWEskNElrjhe9fexR6g8=";

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    substituteInPlace ./src/main.rs \
      --replace-fail '"nix-locate"' '"${lib.getExe' nix-index-unwrapped "nix-locate"}"' \
      --replace-fail '"nix"' '"${lib.getExe nix}"' \
      --replace-fail '"nix-env"' '"${lib.getExe' nix "nix-env"}"' \
      --replace-fail '"fzy"' '"${lib.getExe fzy}"'
  '';

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      ln -s $out/bin/comma $out/bin/,

      mkdir -p $out/share/comma

      cp $src/etc/command-not-found.sh $out/share/comma
      cp $src/etc/command-not-found.nu $out/share/comma
      cp $src/etc/command-not-found.fish $out/share/comma

      patchShebangs $out/share/comma/command-not-found.sh
      substituteInPlace \
        "$out/share/comma/command-not-found.sh" \
        "$out/share/comma/command-not-found.nu" \
        "$out/share/comma/command-not-found.fish" \
        --replace-fail "comma --ask" "$out/bin/comma --ask"
    ''
    + lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      ${emulator} "$out/bin/comma" --mangen > comma.1
      installManPage comma.1

      installShellCompletion --cmd comma \
        --bash <(${emulator} $out/bin/comma --print-completions bash) \
        --fish <(${emulator} $out/bin/comma --print-completions fish) \
        --zsh <(${emulator} $out/bin/comma --print-completions zsh)

      # TODO: Add , to other shells too
      cat >>$out/share/zsh/site-functions/_comma <<'EOF'
        if [ "$funcstack[1]" = "_comma" ]; then
            _comma "$@"
        else
            compdef _comma ,
        fi
      EOF
    '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/nix-community/comma";
    description = "Runs programs without installing them";
    license = lib.licenses.mit;
    mainProgram = "comma";
    maintainers = with lib.maintainers; [ artturin ];
  };
})
