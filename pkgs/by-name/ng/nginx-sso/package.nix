{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "nginx-sso";
  version = "0.27.6";

  src = fetchFromGitHub {
    owner = "Luzifer";
    repo = "nginx-sso";
    rev = "v${version}";
    hash = "sha256-nYqk1VK6R9HH67NLQDUifW3AjIW5pjD1Jmf+cYH3SQo=";
  };

  vendorHash = "sha256-KflzlrjOOTDZQq2yP0zQsDgULrbnoeRRxOVHxKINsYw=";

  postInstall = ''
    mkdir -p $out/share
    cp -R $src/frontend $out/share
  '';

  passthru.tests = {
    inherit (nixosTests) nginx-sso;
  };

  meta = {
    description = "SSO authentication provider for the auth_request nginx module";
    homepage = "https://github.com/Luzifer/nginx-sso";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "nginx-sso";
  };
}
