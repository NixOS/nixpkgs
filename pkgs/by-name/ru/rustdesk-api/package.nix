{
  lib,
  buildGoModule,
  callPackage,
  fetchFromGitHub,
}:
buildGoModule rec {
  __structuredAttrs = true;
  pname = "rustdesk-api";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "lejianwen";
    repo = "rustdesk-api";
    tag = "v${version}";
    hash = "sha256-DZRdwoSuDBGKFmCOSaZroSvbk9WxKz3KlplU7GUcDYc=";
  };

  frontend = callPackage ./frontend.nix { };

  vendorHash = "sha256-/mPZSt54c+97DIQ/lPZ9YKknWd/iqovm3HxTxMfNokE=";
  # Upstream does not check in go.sum. Resolve only the pinned go.mod versions
  # inside the fixed-output dependency derivation before producing vendor/.
  modBuildPhase = ''
    runHook preBuild
    go mod tidy
    go mod vendor
    runHook postBuild
  '';
  subPackages = [ "cmd" ];
  checkPhase = ''
    runHook preCheck
    go test ./utils
    runHook postCheck
  '';

  postInstall = ''
    mv "$out/bin/cmd" "$out/bin/rustdesk-api"
    mkdir -p "$out/share/rustdesk-api/resources"
    cp -r conf "$out/share/rustdesk-api/"
    cp -r resources/{i18n,templates,public} "$out/share/rustdesk-api/resources/"
    # Match upstream release builds, which replace the development version file.
    echo '${version}' > "$out/share/rustdesk-api/resources/version"
    # The optional prebuilt Flutter web clients are deliberately not installed.
    cp -r "$frontend" "$out/share/rustdesk-api/resources/admin"
  '';

  meta = {
    description = "RustDesk API server with address books, management UI and OIDC authentication";
    homepage = "https://github.com/lejianwen/rustdesk-api";
    changelog = "https://github.com/lejianwen/rustdesk-api/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "rustdesk-api";
    maintainers = [ lib.maintainers.xiongchenyu6 ];
    platforms = lib.platforms.linux;
  };
}
