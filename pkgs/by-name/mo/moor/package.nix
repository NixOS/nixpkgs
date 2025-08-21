{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "moor";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "moor";
    rev = "v${version}";
    hash = "sha256-pwpYnzcQwT9kG1J0L8PuWPR9/ymMYlfiVJkTWFaZ2Eo=";
  };

  vendorHash = "sha256-ComKeqnw1PvDaCRVXfInRjSzhyZWGkD/hp5piwhwxds=";

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
