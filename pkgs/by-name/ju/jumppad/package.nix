{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jumppad";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "jumppad-labs";
    repo = "jumppad";
    rev = version;
    hash = "sha256-V+FDPNNNP7HMg0Somoj3EhGuhhq/Du8JcCBE/Ut2V1s=";
  };
  vendorHash = "sha256-BuXbizA/OJiP11kSIO476tWPYPzGTKmzPHeyIqs8pWc=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X main.version=${version}"
  ];

  # Tests require a large variety of tools and resources to run including
  # Kubernetes, Docker, and GCC.
  doCheck = false;

  meta = with lib; {
    description = "Tool for building modern cloud native development environments";
    homepage = "https://jumppad.dev";
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud ];
    mainProgram = "jumppad";
  };
}
