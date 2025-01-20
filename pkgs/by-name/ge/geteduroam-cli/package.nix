{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:
buildGoModule rec {
  pname = "geteduroam-cli";
  version = "0.4";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchFromGitHub {
    owner = "geteduroam";
    repo = "linux-app";
    rev = version;
    hash = "sha256-9+IjrHg536/6ulj94CBhYWY0S3aNA7Ne4JQynMmsLxE=";
  };

  vendorHash = "sha256-9SNjOC59wcEkxJqBXsgYClHKGH7OFWk3t/wMPLANAy0=";

  subPackages = [
    "cmd/geteduroam-cli"
  ];

  meta = with lib; {
    description = "CLI client to configure eduroam";
    mainProgram = "geteduroam-cli";
    homepage = "https://github.com/geteduroam/linux-app";
    license = licenses.bsd3;
    maintainers = with maintainers; [ viperML ];
    platforms = platforms.linux;
  };
}
