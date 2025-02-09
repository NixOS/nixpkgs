{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "nginx-sso";
  version = "0.27.4";

  src = fetchFromGitHub {
    owner = "Luzifer";
    repo = "nginx-sso";
    rev = "v${version}";
    hash = "sha256-fNMCskS8uXAykl2Zu4ZZqtIS2F5w7HV7C8hyPaWnav4=";
  };

  vendorHash = "sha256-J3CObmSbrAn0D5MOaclRvlnqLqUYfQCkfD6om/tNKac=";

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
