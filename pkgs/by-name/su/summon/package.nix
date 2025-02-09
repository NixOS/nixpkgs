{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "summon";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "cyberark";
    repo = "summon";
    rev = "v${version}";
    hash = "sha256-W0KTZPxPY8sFZD1dB6fSo+YB0EDMD71TsPs98EbgM1Q=";
  };

  vendorHash = "sha256-StcJvUtMfBh7p1sD8ucvHNJ572whRfqz3id6XsFoXtk=";

  subPackages = [ "cmd" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/summon
  '';

  meta = with lib; {
    description = "CLI that provides on-demand secrets access for common DevOps tools";
    mainProgram = "summon";
    homepage = "https://cyberark.github.io/summon";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ quentini ];
  };
}
