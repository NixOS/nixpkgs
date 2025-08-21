{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "moor";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "moor";
    rev = "v${version}";
    hash = "sha256-l88el60KCdUwtiF9aEMO3bHud/TR+HahPBk2/H+tt28=";
  };

  vendorHash = "sha256-7FkYHFSwjK45EZEgS2yhaWxAhrAtuOjoWxPWABa5pvA=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ./moor.1
  '';

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.versionString=v${version}"
  ];

  meta = with lib; {
    description = "Nice-to-use pager for humans";
    homepage = "https://github.com/walles/moor";
    license = licenses.bsd2WithViews;
    mainProgram = "moor";
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
