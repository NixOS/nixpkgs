{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "nginx-sso";
<<<<<<< HEAD
  version = "0.27.6";
=======
  version = "0.27.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Luzifer";
    repo = "nginx-sso";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-nYqk1VK6R9HH67NLQDUifW3AjIW5pjD1Jmf+cYH3SQo=";
  };

  vendorHash = "sha256-KflzlrjOOTDZQq2yP0zQsDgULrbnoeRRxOVHxKINsYw=";
=======
    hash = "sha256-fNMCskS8uXAykl2Zu4ZZqtIS2F5w7HV7C8hyPaWnav4=";
  };

  vendorHash = "sha256-J3CObmSbrAn0D5MOaclRvlnqLqUYfQCkfD6om/tNKac=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postInstall = ''
    mkdir -p $out/share
    cp -R $src/frontend $out/share
  '';

  passthru.tests = {
    inherit (nixosTests) nginx-sso;
  };

<<<<<<< HEAD
  meta = {
    description = "SSO authentication provider for the auth_request nginx module";
    homepage = "https://github.com/Luzifer/nginx-sso";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ambroisie ];
=======
  meta = with lib; {
    description = "SSO authentication provider for the auth_request nginx module";
    homepage = "https://github.com/Luzifer/nginx-sso";
    license = licenses.asl20;
    maintainers = with maintainers; [ ambroisie ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "nginx-sso";
  };
}
