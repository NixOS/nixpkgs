{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "matterbox";
  version = "1.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cornedor";
    repo = "matterbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-77d1VLq4d44AhLt17W5sTzpJM6sG9du8CkSm2rtWzXA=";
  };

  vendorHash = "sha256-VnkgkJMAEV1x+RCz4FOAwZNYOtVPGJ2drOCcqiqlZco=";

  nativeBuildInputs = [ installShellFiles ];

  # Nixpkgs currently carries Go 1.26.1, while upstream unnecessarily pins
  # the minimum to the newer patch release.
  postPatch = ''
    substituteInPlace go.mod --replace-fail "go 1.26.3" "go 1.26.1"
  '';

  # The Makefile selects optional features based on impure host library
  # detection. Keep the package portable by explicitly building the base TUI.
  dontBuild = true;

  checkPhase = ''
    runHook preCheck
    oldGOFLAGS="$GOFLAGS"
    export GOFLAGS="''${GOFLAGS//-trimpath/}"
    make test TAGS=
    export GOFLAGS="$oldGOFLAGS"
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    make install \
      PREFIX="$out" \
      HOME="$TMPDIR" \
      XDG_DATA_HOME="$TMPDIR/.local/share" \
      TAGS= \
      VERSION="v${finalAttrs.version}"

    installShellCompletion --cmd matterbox \
      --bash <($out/bin/matterbox completion bash) \
      --fish <($out/bin/matterbox completion fish) \
      --zsh <($out/bin/matterbox completion zsh)

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal client for Mattermost with a TUI and scriptable CLI";
    homepage = "https://github.com/cornedor/matterbox";
    changelog = "https://github.com/cornedor/matterbox/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "matterbox";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
