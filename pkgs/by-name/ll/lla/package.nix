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
  version = "0.3.7";
in
rustPlatform.buildRustPackage {
  pname = "lla";
  inherit version;

  src = fetchFromGitHub {
    owner = "triyanox";
    repo = "lla";
    tag = "v${version}";
    hash = "sha256-8BnYLC5SGFvk9srRyLxflDgfVbbGMSHXBOjXQLMLIi8=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    installShellFiles
  ];

  cargoHash = "sha256-H/BnJiR9+wcddAEWkKaqamTEDgjTUOMq1AiGWQAfjDM=";

  cargoBuildFlags = [ "--workspace" ];

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
      `lla` is a high-performance file explorer written in Rust that enhances the traditional
      `ls` command with modern features, rich formatting options, and a powerful plugin system.
    '';
    homepage = "https://github.com/triyanox/lla";
    changelog = "https://github.com/triyanox/lla/blob/refs/tags/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = lib.platforms.unix;
    mainProgram = "lla";
  };
}
