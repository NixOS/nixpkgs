{ buildGoModule
, fetchFromGitHub
, getent
, lib
, makeWrapper
, stdenv
, xdg-utils
}:
buildGoModule rec {
  pname = "aws-sso-cli";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "synfinatic";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VEI+vCNeNoFOE+2j/OUjRszXsUQP2E1iUdPUW9X3tHk=";
  };
  vendorHash = "sha256-a57RtK8PxwaRrSA6W6R//GacZ+pK8mBi4ZASS5NvShE=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-X main.Version=${version}"
    "-X main.Tag=nixpkgs"
  ];

  postInstall = ''
    wrapProgram $out/bin/aws-sso \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  nativeCheckInputs = [ getent ];

  checkFlags = [
    "-skip=TestAWSConsoleUrl|TestAWSFederatedUrl"
  ] ++ lib.optionals stdenv.isDarwin [ "--skip=TestDetectShellBash" ];

  meta = with lib; {
    homepage = "https://github.com/synfinatic/aws-sso-cli";
    description = "AWS SSO CLI is a secure replacement for using the aws configure sso wizard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ devusb ];
    mainProgram = "aws-sso";
  };
}
