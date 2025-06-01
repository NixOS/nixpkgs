{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "moar";
  version = "1.31.7";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "moar";
    rev = "v${version}";
    hash = "sha256-0/V9baRscZFMyvVsSfmxZJdd22BgqqdGcKa7rh210x8=";
  };

  vendorHash = "sha256-J9u7LxzXk4npRyymmMKyN2ZTmhT4WwKjy0X5ITcHtoE=";

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
