{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "docker-color-output";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "devemio";
    repo = "docker-color-output";
    tag = version;
    hash = "sha256-r11HNRXnmTC1CJR871sX7xW9ts9KAu1+azwIwXH09qg=";
  };

  postInstall = ''
    mv $out/bin/cli $out/bin/docker-color-output
  '';

  vendorHash = null;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Add color to the Docker CLI";
    mainProgram = "docker-color-output";
    license = lib.licenses.mit;
    homepage = "https://github.com/devemio/docker-color-output";
    changelog = "https://github.com/devemio/docker-color-output/releases/tag/${version}";
    maintainers = with lib.maintainers; [ sguimmara ];
  };
}
