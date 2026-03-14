{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
  externalPlugins ? [ ],
  vendorHash ? "sha256-qodzzBee+4NeZ+XifMknFPayBcWDmbyYq1R6Xhuras0=",
}:

let
  attrsToSources = attrs: map ({ repo, version, ... }: "${repo}@${version}") attrs;
in
buildGoModule (finalAttrs: {
  pname = "coredns";
  version = "1.14.2";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c0xXZnc0muXViPqMCJsD8TTGMbVCOKE49ElAHEPnKlw=";
  };

  inherit vendorHash;

  nativeBuildInputs = [ installShellFiles ];

  outputs = [
    "out"
    "man"
  ];

  overrideModAttrs = {
    # Add plugins before vendoring the modules.
    preBuild = ''
      cp plugin.cfg plugin.cfg.orig
      ${
        (lib.concatMapStringsSep "\n" (
          plugin:
          let
            position = plugin.position or "end-of-file";
            formatPlugin = { name, repo, ... }: "${name}:${repo}";
          in
          if position == "end-of-file" then
            "echo '${formatPlugin plugin}' >> plugin.cfg"
          else if position == "start-of-file" then
            "sed -i '1i ${formatPlugin plugin}' plugin.cfg"
          else if lib.hasAttrByPath [ "before" ] position then
            ''
              if ! grep -q '^${position.before}:' plugin.cfg; then
                echo 'Failed to insert ${plugin.name} before ${position.before} in plugin.cfg: ${position.before} is not in plugin.cfg'
                exit 1
              fi
              sed -i '/^${position.before}:/i ${formatPlugin plugin}' plugin.cfg
            ''
          else if lib.hasAttrByPath [ "after" ] position then
            ''
              if ! grep -q '^${position.after}:' plugin.cfg; then
                echo 'Failed to insert ${plugin.name} after ${position.after} in plugin.cfg: ${position.after} is not in plugin.cfg'
                exit 1
              fi
              sed -i '/^${position.after}:/a ${formatPlugin plugin}' plugin.cfg
            ''
          else
            throw ''
              Unsupported position value in externalPlugin:
                ${builtins.toJSON plugin}.
              Valid values for position attr are:
                - position = "end-of-file" (the default)
                - position = "start-of-file"
                - position.before = "{other plugin}"
                - position.after = "{other plugin}"
            ''
        ) externalPlugins)
      }
      diff -u plugin.cfg.orig plugin.cfg || true
      for src in ${toString (attrsToSources externalPlugins)}; do go get $src; done
      GOFLAGS=''${GOFLAGS//-mod=vendor/} CC= GOOS= GOARCH= go generate
      go mod tidy
    '';

    # Move the modified `go.mod`, `go.sum`, and `plugin.cfg` files into the
    # vendor directory so we can retrieve them later in the `preBuild` hook.
    postBuild = ''
      mv -t vendor go.mod go.sum plugin.cfg
    '';
  };

  preBuild = ''
    chmod -R u+w vendor
    mv -t . vendor/go.{mod,sum} vendor/plugin.cfg

    CC= GOOS= GOARCH= go generate
  '';

  postPatch = ''
    substituteInPlace test/file_cname_proxy_test.go \
      --replace-fail \
        "TestZoneExternalCNAMELookupWithProxy" \
        "SkipZoneExternalCNAMELookupWithProxy"

    substituteInPlace test/readme_test.go \
      --replace-fail "TestReadme" "SkipReadme"

    substituteInPlace test/metrics_test.go \
      --replace-fail "TestMetricsRewriteRequestSize" "SkipMetricsRewriteRequestSize"

    substituteInPlace test/quic_test.go \
      --replace-fail "TestQUICReloadDoesNotPanic" "SkipQUICReloadDoesNotPanic"

    # this test fails if any external plugins were imported.
    # it's a lint rather than a test of functionality, so it's safe to disable.
    substituteInPlace test/presubmit_test.go \
      --replace-fail "TestImportOrdering" "SkipImportOrdering"

    substituteInPlace plugin/pkg/parse/transport_test.go \
      --replace-fail \
        "TestTransport" \
        "SkipTransport"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # loopback interface is lo0 on macos
    sed -E -i 's/\blo\b/lo0/' plugin/bind/setup_test.go

    # test is apparently outdated but only exhibits this on darwin
    substituteInPlace test/corefile_test.go \
      --replace-fail "TestCorefile1" "SkipCorefile1"
  '';

  __darwinAllowLocalNetworking = true;

  postInstall = ''
    installManPage man/*
  '';

  passthru.tests = {
    coredns-external-plugins = nixosTests.coredns;
    kubernetes-single-node = nixosTests.kubernetes.dns-single-node;
    kubernetes-multi-node = nixosTests.kubernetes.dns-multi-node;
  };

  meta = {
    homepage = "https://coredns.io";
    description = "DNS server that runs middleware";
    mainProgram = "coredns";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      deltaevo
      djds
      johanot
      rtreffer
      rushmorem
    ];
  };
})
