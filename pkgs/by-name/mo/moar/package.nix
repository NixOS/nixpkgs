{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "moar";
  version = "1.32.2";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "moar";
    rev = "v${version}";
    hash = "sha256-iv5rvIf/4bRgaFUNnXvANEynNUVQv4twK21ZJhpxLXU=";
  };

  vendorHash = "sha256-eKL6R2Xmj6JOwXGuJJdSGwobEzDzZ0FUD8deO2d1unc=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ./moar.1
  '';

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.versionString=v${version}"
  ];

  meta = with lib; {
    description = "Nice-to-use pager for humans";
    homepage = "https://github.com/walles/moar";
    license = licenses.bsd2WithViews;
    mainProgram = "moar";
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
