{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "notify";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "notify";
    rev = "v${version}";
    sha256 = "sha256-QXioBUCMZ4ANkF2WOXiKUlExVq4abkaVFBd3efAGXMs=";
  };

  vendorHash = "sha256-jO9d+wJr03rqlPrQ3mmWOxOXw2kL+0x8YkkXu/Msm+Q=";

  modRoot = ".";
  subPackages = [
    "cmd/notify/"
  ];

  # Test files are not part of the release tarball
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Allows sending the output from any tool to Slack, Discord and Telegram";
    longDescription = ''
      Notify is a helper utility written in Go that allows you to post the output from any tool
      to Slack, Discord, and Telegram.
    '';
    homepage = "https://github.com/projectdiscovery/notify";
    license = licenses.mit;
    maintainers = with maintainers; [ hanemile ];
    mainProgram = "notify";
  };
}
