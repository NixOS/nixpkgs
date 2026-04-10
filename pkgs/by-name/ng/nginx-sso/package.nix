{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "nginx-sso";
  version = "0.27.7";

  src = fetchFromGitHub {
    owner = "Luzifer";
    repo = "nginx-sso";
    rev = "v${version}";
    hash = "sha256-vGap7FjBISlvJeu+n70Rhqugi07uAnqHFKCV9cprpBA=";
  };

  vendorHash = "sha256-1gP5arImDp9pjPMc5kdW/Fba4IjbHJBLi3FZlHcHe2s=";

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
