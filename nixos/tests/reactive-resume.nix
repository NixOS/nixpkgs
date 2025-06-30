{ lib, pkgs, ... }:
let
  nodeName = "machine";
in
{
  name = "reactive-resume";

  nodes.${nodeName}.services.reactive-resume = {
    chromeUrl = "ws://127.0.0.1:8080";
    enable = true;
    secretsFile = pkgs.writeText "reactive-resume-secrets" ''
      # Authentication
      ACCESS_TOKEN_SECRET='my access token secret'
      REFRESH_TOKEN_SECRET='my refresh token secret'

      # Chrome
      CHROME_TOKEN='my Chrome token'

      # Storage
      STORAGE_ACCESS_KEY='my storage access key'
      STORAGE_SECRET_KEY='my storage secret key'
    '';
  };

  testScript = ''
    start_all()
    ${nodeName}.wait_for_unit("reactive-resume")
  '';

  meta.maintainers = with lib.maintainers; [ l0b0 ];
}
