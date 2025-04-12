{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "nginx-sso";
  version = "0.27.3";

  src = fetchFromGitHub {
    owner = "Luzifer";
    repo = "nginx-sso";
    rev = "v${version}";
    hash = "sha256-8ZfNHjf5sbcBasu3o3AHCL0tGROixdNZkDF9yd/uPbs=";
  };

  vendorHash = "sha256-bquK6/xT+xhEGBDeNN3U1qwSxrHWQhdHNuw9RXoqM+8=";

  postInstall = ''
    mkdir -p $out/share
    cp -R $src/frontend $out/share
  '';

  passthru.tests = {
    inherit (nixosTests) nginx-sso;
  };

  meta = with lib; {
    description = "SSO authentication provider for the auth_request nginx module";
    homepage = "https://github.com/Luzifer/nginx-sso";
    license = licenses.asl20;
    maintainers = with maintainers; [ ambroisie ];
    mainProgram = "nginx-sso";
  };
}
