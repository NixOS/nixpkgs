{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "monsoon";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "RedTeamPentesting";
    repo = "monsoon";
    rev = "refs/tags/v${version}";
    hash = "sha256-efVwOon499DUJ17g6aQveMd2g544Ck+/P7VttYnR+No=";
  };

  vendorHash = "sha256-i96VDKNRNrkrkg2yBd+muXIQK0vZCGIoQrZsq+kBMsk=";

  # Tests fails on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Fast HTTP enumerator";
    mainProgram = "monsoon";
    longDescription = ''
      A fast HTTP enumerator that allows you to execute a large number of HTTP
      requests, filter the responses and display them in real-time.
    '';
    homepage = "https://github.com/RedTeamPentesting/monsoon";
    changelog = "https://github.com/RedTeamPentesting/monsoon/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
