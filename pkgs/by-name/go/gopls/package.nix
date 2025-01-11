{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gopls";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    hash = "sha256-NLUIFNooOOA4LEL5nZNdP9TvDkQUqLjKi44kZtOxeuI=";
  };

  modRoot = "gopls";
  vendorHash = "sha256-wH3YRiok3YWNzw9ejXMMitq58SxrNWXiKYKz2Hf0ZlM=";

  # https://github.com/golang/tools/blob/9ed98faa/gopls/main.go#L27-L30
  ldflags = [ "-X main.version=v${version}" ];

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    changelog = "https://github.com/golang/tools/releases/tag/${src.rev}";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      mic92
      rski
      SuperSandro2000
      zimbatm
    ];
    mainProgram = "gopls";
  };
}
