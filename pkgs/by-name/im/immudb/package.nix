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
buildGoModule rec {
  pname = "immudb";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "codenotary";
    repo = "immudb";
    rev = "v${version}";
    sha256 = "sha256-RsDM+5/a3huBJ6HfaALpw+KpcIfg198gZfC4c4DsDlU=";
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
    go generate -tags webconsole ./webconsole
  '';

  vendorHash = "sha256-6DHmJrE+xkf8K38a8h1VSD33W6qj594Q5bJJXnfSW0Q=";

  nativeBuildInputs = [ installShellFiles ];

  tags = [ "webconsole" ];

  ldflags = [ "-X github.com/codenotary/immudb/cmd/version.Version=${version}" ];

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

  meta = with lib; {
    description = "Immutable database based on zero trust, SQL and Key-Value, tamperproof, data change history";
    homepage = "https://github.com/codenotary/immudb";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
