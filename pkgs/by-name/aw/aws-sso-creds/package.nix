{
  buildGoModule,
  fetchFromGitHub,
  lib,
  makeWrapper,
  xdg-utils,
}:
buildGoModule rec {
  pname = "aws-sso-creds";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "jaxxstorm";
    repo = "aws-sso-creds";
    rev = "v${version}";
    sha256 = "sha256-QYE+HvvBEWPxopVP8QMqb4lNRyAtVDewuiWzja9XdM4=";
  };
  vendorHash = "sha256-2EDpyw7Mqhvc0i6+UjWfNlvndRYJDaezRkOy9PBeD1Y=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/aws-sso-creds \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/jaxxstorm/aws-sso-creds";
    description = "Get AWS SSO temporary creds from an SSO profile";
    license = licenses.mit;
    maintainers = with maintainers; [ lafrenierejm ];
    mainProgram = "aws-sso-creds";
  };
}
