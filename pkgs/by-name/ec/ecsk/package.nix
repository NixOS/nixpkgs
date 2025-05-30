{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "ecsk";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "yukiarrr";
    repo = "ecsk";
    tag = "v${version}";
    hash = "sha256-1nrV7NslOIXQDHsc7c5YfaWhoJ8kfkEQseoVVeENrHM=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-Eyqpc7GyG/7u/I4tStADQikxcbIatjeAJN9wUDgzdFY=";

  subPackages = [ "cmd/ecsk" ];

  meta = {
    description = "Interactively call Amazon ECS APIs, copy files between ECS and local, and view logs";
    license = lib.licenses.mit;
    mainProgram = "ecsk";
    homepage = "https://github.com/yukiarrr/ecsk";
    maintainers = with lib.maintainers; [ whtsht ];
  };
}
