{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  python3,
}:

buildGoModule rec {
  pname = "bbctl";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "beeper";
    repo = "bridge-manager";
    tag = "v${version}";
    hash = "sha256-bNnansZNshWp70LQQsa6+bS+LJxpCzdTkL2pX+ksrP0=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  vendorHash = "sha256-yTNUxwnulQ+WbHdQbeNDghH4RPXurQMIgKDyXfrMxG8=";

  postInstall = ''
    wrapProgram $out/bin/bbctl \
      --prefix PATH : ${python3}/bin
  '';

  meta = {
    description = "Tool for running self-hosted bridges with the Beeper Matrix server";
    homepage = "https://github.com/beeper/bridge-manager";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.heywoodlh ];
    mainProgram = "bbctl";
    changelog = "https://github.com/beeper/bridge-manager/releases/tag/v${version}";
  };
}
