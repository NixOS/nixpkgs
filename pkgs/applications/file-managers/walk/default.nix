{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "walk";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "walk";
    rev = "v${version}";
    hash = "sha256-hif62WAyJyFHpJoP3ph7gJk1QkEL7qkcv/BJuoXkwFU=";
  };

  vendorHash = "sha256-e292ke0JiFEopLSozb+FkpwzSuhpIs/PdWOYuNI2M2o=";

  meta = with lib; {
    description = "Terminal file manager";
    homepage = "https://github.com/antonmedv/walk";
    license = licenses.mit;
    maintainers = with maintainers; [
      portothree
      surfaceflinger
    ];
    mainProgram = "walk";
  };
}
