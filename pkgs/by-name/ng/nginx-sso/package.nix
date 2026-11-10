{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "nginx-sso";
  version = "0.27.9";

  src = fetchFromGitHub {
    owner = "Luzifer";
    repo = "nginx-sso";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XG+zy2QAUFRXHdMrIuaXUaVNyUfpNAJ0WhZuyO6b+H4=";
  };

  vendorHash = "sha256-RAOaYLf2SOBnyceMo6Da2BNpuWvjdweF5L9nRM392R8=";

  postInstall = ''
    mkdir -p $out/share
    cp -R $src/frontend $out/share
  '';

  passthru.tests = {
    nginx-sso = nixosTests.nginx.mainline.sso;
  };

  meta = {
    description = "SSO authentication provider for the auth_request nginx module";
    homepage = "https://github.com/Luzifer/nginx-sso";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "nginx-sso";
  };
})
