{
  buildGo124Module,
  fetchFromGitHub,
  lib,
  installShellFiles,
}:

buildGo124Module rec {
  pname = "golangci-lint";
  version = "1.64.6";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    rev = "v${version}";
    hash = "sha256-uJKZRJx+hUCXrLrLq1UcBknRSR/o+R9trfacgg27MLs=";
  };

  vendorHash = "sha256-6vL6lYZcpi9roRa+sFbQPq4Ysd8TM3j40wg68B5VbX0=";

  subPackages = [ "cmd/golangci-lint" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-X main.version=${version}"
    "-X main.commit=v${version}"
    "-X main.date=19700101-00:00:00"
  ];

  postInstall = ''
    for shell in bash zsh fish; do
      HOME=$TMPDIR $out/bin/golangci-lint completion $shell > golangci-lint.$shell
      installShellCompletion golangci-lint.$shell
    done
  '';

  meta = with lib; {
    description = "Fast linters Runner for Go";
    homepage = "https://golangci-lint.run/";
    changelog = "https://github.com/golangci/golangci-lint/blob/v${version}/CHANGELOG.md";
    mainProgram = "golangci-lint";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      SuperSandro2000
      mic92
    ];
  };
}
