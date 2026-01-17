{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule rec {
  pname = "diun";
  version = "4.31.0";

  src = fetchFromGitHub {
    owner = "crazy-max";
    repo = "diun";
    rev = "v${version}";
    hash = "sha256-H05yZSH2rUrwM+ZR/PDCxXmrDkZ/Gd4RrpywGk5eW2A=";
  };
  vendorHash = null;

  doCheck = false; # Tests require a network connection.

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.version=${version}"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  postInstall = ''
    mv $out/bin/cmd $out/bin/diun
  '';

  meta = with lib; {
    description = "CLI application to receive notifications when a Docker image is updated on a Docker registry";
    homepage = "https://github.com/crazy-max/diun";
    license = licenses.mit;
    mainProgram = "diun";
    maintainers = with maintainers; [ Sped0n ];
    platforms = platforms.unix;
  };
}
