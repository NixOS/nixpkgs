{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "monsoon";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "RedTeamPentesting";
    repo = "monsoon";
    tag = "v${version}";
    hash = "sha256-vgwoW7jrcLVHDm1cYrIpFcfrgKImCAVOtHg8lMQ6aic=";
  };

  vendorHash = "sha256-hGEUO1sl8IKXo4rkS81Wlf7187lu2PrSujNlGNTLwmE=";

  # Tests fails on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Fast HTTP enumerator";
    mainProgram = "monsoon";
    longDescription = ''
      A fast HTTP enumerator that allows you to execute a large number of HTTP
      requests, filter the responses and display them in real-time.
    '';
    homepage = "https://github.com/RedTeamPentesting/monsoon";
    changelog = "https://github.com/RedTeamPentesting/monsoon/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
