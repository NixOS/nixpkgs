{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:
let
  version = "0.4.2";
in
rustPlatform.buildRustPackage {
  pname = "lla";
  inherit version;

  src = fetchFromGitHub {
    owner = "chaqchase";
    repo = "lla";
    tag = "v${version}";
    hash = "sha256-7/VfEcqvYGC1Pw9wJh5FF3c7BXgcg9LVDvcr4zCrros=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    installShellFiles
  ];

  cargoHash = "sha256-LYRNXNhPgpNZWP5XKqfgM6t9Ts2k/e09iXWMcuEp9LA=";

  cargoBuildFlags = [ "--workspace" ];

  # TODO: Upstream also provides Elvish and PowerShell completions,
  # but `installShellCompletion` only has support for Bash, Zsh and Fish at the moment.
  postInstall = ''
    installShellCompletion completions/{_lla,lla{.bash,.fish}}
  '';

  postFixup = ''
    wrapProgram $out/bin/lla \
      --add-flags "--plugins-dir $out/lib"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Blazing-fast `ls` replacement with superpowers";
    longDescription = ''
      `lla` is a modern `ls` replacement that transforms how developers interact with their filesystem.
      Built with Rust's performance capabilities and designed with user experience in mind,
      `lla` combines the familiarity of ls with powerful features like specialized views,
      Git integration, and a robust plugin system with an extensible list of plugins to add more functionality.
    '';
    homepage = "https://lla.chaqchase.com";
    changelog = "https://github.com/chaqchase/lla/blob/refs/tags/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = lib.platforms.unix;
    mainProgram = "lla";
  };
}
