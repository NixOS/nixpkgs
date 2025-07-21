{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rakkess";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "corneliusweig";
    repo = "rakkess";
    rev = "v${version}";
    sha256 = "sha256-igovWWk8GfNmOS/NbZWfv9kox6QLNIbM09jdvA/lL3A=";
  };
  vendorHash = "sha256-lVxJ4wFBhHc8JVpkmqphLYPE9Z8Cr6o+aAHvC1naqyE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/corneliusweig/rakkess/internal/version.version=v${version}"
  ];

  meta = {
    homepage = "https://github.com/corneliusweig/rakkess";
    changelog = "https://github.com/corneliusweig/rakkess/releases/tag/v${version}";
    description = "Review Access - kubectl plugin to show an access matrix for k8s server resources";
    mainProgram = "rakkess";
    longDescription = ''
      Have you ever wondered what access rights you have on a provided
      kubernetes cluster? For single resources you can use
      `kubectl auth can-i list deployments`, but maybe you are looking for a
      complete overview? This is what rakkess is for. It lists access rights for
      the current user and all server resources, similar to
      `kubectl auth can-i --list`.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jk ];
  };
}
