{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
  externalPlugins ? [ ],
  vendorHash ? "sha256-Es3xy8NVDo7Xgu32jJa4lhYWGa5hJnRyDKFYQqB3aBY=",
}:

let
  attrsToSources = attrs: map ({ repo, version, ... }: "${repo}@${version}") attrs;
in
buildGoModule (finalAttrs: {
  pname = "coredns";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P4GhWrEACR1ZhNhGAoXWvNXYlpwnm2dz6Ggqv72zYog=";
  };

  inherit vendorHash;

  nativeBuildInputs = [ installShellFiles ];

  outputs = [
    "out"
    "man"
  ];

  # Override the go-modules fetcher derivation to fetch plugins
  modBuildPhase = ''
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
    GOOS= GOARCH= go generate
    go mod vendor
  '';

  modInstallPhase = ''
    mv -t vendor go.mod go.sum plugin.cfg
    cp -r --reflink=auto vendor "$out"
  '';

  preBuild = ''
    chmod -R u+w vendor
    mv -t . vendor/go.{mod,sum} vendor/plugin.cfg

    GOOS= GOARCH= go generate
  '';

  postPatch = ''
    substituteInPlace test/file_cname_proxy_test.go \
      --replace-fail \
        "TestZoneExternalCNAMELookupWithProxy" \
        "SkipZoneExternalCNAMELookupWithProxy"

    substituteInPlace test/readme_test.go \
      --replace-fail "TestReadme" "SkipReadme"

    # this test fails if any external plugins were imported.
    # it's a lint rather than a test of functionality, so it's safe to disable.
    substituteInPlace test/presubmit_test.go \
      --replace-fail "TestImportOrdering" "SkipImportOrdering"
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
      rtreffer
      rushmorem
    ];
  };
})
