{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchzip,
  installShellFiles,
}:

let
  webconsoleVersion = "1.0.18";
  webconsoleDist = fetchzip {
    url = "https://github.com/codenotary/immudb-webconsole/releases/download/v${webconsoleVersion}/immudb-webconsole.tar.gz";
    sha256 = "sha256-4BhTK+gKO8HW1CelGa30THpfkqfqFthK+b7p9QWl4Pw=";
  };
in
buildGoModule (finalAttrs: {
  pname = "immudb";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "codenotary";
    repo = "immudb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S+X52zxIJj9uJhvSk0aGrEvLKKoa0BciQW5nAgPRtrc=";
  };

  postPatch = ''
    EXPECTED_WEBCONSOLE_STRING='DEFAULT_WEBCONSOLE_VERSION=${webconsoleVersion}'
    if ! grep -F "$EXPECTED_WEBCONSOLE_STRING" Makefile ; then
      echo "Did not find $EXPECTED_WEBCONSOLE_STRING in Makefile. " \
        "Our webconsole version may need bumping (or the Makefile may have changed)"
      exit 3
    fi
  '';

  preBuild = ''
    mkdir -p webconsole/dist
    cp -r ${webconsoleDist}/* ./webconsole/dist
    go generate -mod=mod -tags webconsole ./webconsole
  '';

  vendorHash = "sha256-7/TR+YjeeTQk+kY2WjYBeiP94onLJXrjJijYl5N6cPc=";

  nativeBuildInputs = [ installShellFiles ];

  tags = [ "webconsole" ];

  ldflags = [ "-X github.com/codenotary/immudb/cmd/version.Version=${finalAttrs.version}" ];

  subPackages = [
    "cmd/immudb"
    "cmd/immuclient"
    "cmd/immuadmin"
  ];

  postInstall = ''
    mkdir -p share/completions
    for executable in immudb immuclient immuadmin; do
      for shell in bash fish zsh; do
        $out/bin/$executable completion $shell > share/completions/$executable.$shell
        installShellCompletion share/completions/$executable.$shell
      done
    done
  '';

  meta = {
    changelog = "https://github.com/codenotary/immudb/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Immutable database based on zero trust, SQL and Key-Value, tamperproof, data change history";
    homepage = "https://github.com/codenotary/immudb";
    license = with lib.licenses; [
      asl20
      bsl11
    ];
    maintainers = with lib.maintainers; [ hythera ];
  };
})
