{
  lib,
  stdenv,
  autoPatchelfHook,
  cacert,
  fetchurl,
  makeBinaryWrapper,
  bash,
  nodejs,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "github-copilot-cli";
  version = "1.0.26";

  # GitHub provide platform-specific SEA binaries as well as a "universal"
  # package.  Use the universal package as it gives us a bit more flexibility
  # about how it's configured.  In particular, the SEA binary has fixed ideas
  # about how paths should be set up which don't reliably hold when using Nix.
  src = fetchurl {
    url = "https://github.com/github/copilot-cli/releases/download/v${finalAttrs.version}/github-copilot-${finalAttrs.version}.tgz";
    hash = "sha256-zNO0clQRfgw6CX9K8NaJXsoOhhNjBfK7KAr0AoL7Oqo=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];
  sourceRoot = "package";
  dontStrip = true;
  # keytar.node and computer.node have optional system-library deps not provided
  # here; ignore missing deps rather than fail the build.
  autoPatchelfIgnoreMissingDeps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"/lib/github-copilot-cli
    cp -r * "$out"/lib/github-copilot-cli
    runHook postInstall
  '';

  postInstall = ''
    makeWrapper ${nodejs}/bin/node "$out"/bin/copilot \
      --add-flag "$out"/lib/github-copilot-cli/index.js \
      --add-flag --no-auto-update \
      --set-default NODE_NO_WARNINGS 1 \
      --set-default SSL_CERT_DIR ${cacert}/etc/ssl/certs \
      --prefix PATH : "${lib.makeBinPath [ bash ]}"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  # TODO are these errors still present after moving to using the "universal"
  # package?
  doInstallCheck = !stdenv.hostPlatform.isDarwin; # skip on Darwin - OpenSSL errors in sandbox

  # Looks like GitHub use tags for both pre-release and actually released
  # versions, but only the actual versions will be available as a GitHub
  # release, so use the release endpoint rather than nix-update-script`'s
  # default of looking for tags.
  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "GitHub Copilot CLI brings the power of Copilot coding agent directly to your terminal";
    homepage = "https://github.com/github/copilot-cli";
    changelog = "https://github.com/github/copilot-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      dbreyfogle
    ];
    mainProgram = "copilot";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
