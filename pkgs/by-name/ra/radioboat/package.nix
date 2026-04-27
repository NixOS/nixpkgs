{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  mpv,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radioboat";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "slashformotion";
    repo = "radioboat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1fTXXT0HxGOoy+oNK1ixzgFgjapreQEOoVlQlJwqbrA=";
  };

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'version = "0.4.0"' 'version = "${finalAttrs.version}"'
  '';

  __structuredAttrs = true;

  cargoHash = "sha256-ibDOUgprr5VziIvTpvDFISGVpVH5ZyQ1ZZ5tIQirPP8=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  preFixup = ''
    wrapProgram $out/bin/radioboat --prefix PATH ":" "${lib.makeBinPath [ mpv ]}";
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd radioboat \
      --bash <($out/bin/radioboat completion bash) \
      --fish <($out/bin/radioboat completion fish) \
      --zsh <($out/bin/radioboat completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;

  meta = {
    description = "Terminal web radio client";
    homepage = "https://github.com/slashformotion/radioboat";
    changelog = "https://github.com/slashformotion/radioboat/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "radioboat";
    platforms = lib.platforms.linux;
  };
})
