{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "ficsit-cli";
  version = "0.6.0";
  commit = "5dc8bdbaf6e8d9b1bcd2895e389d9d072d454e15";

  src = fetchFromGitHub {
    owner = "satisfactorymodding";
    repo = "ficsit-cli";
    tag = "v${version}";
    hash = "sha256-Zwidx0war3hos9NEmk9dEzPBgDGdUtWvZb7FIF5OZMA=";
  };

  ldflags = [
    "-X=main.version=v${version}"
    "-X=main.commit=${commit}"
  ];

  doCheck = false; # Tests make an api call, which always fails in the sandbox.

  vendorHash = "sha256-vmA3jvxOLRYj5BmvWMhSEnCTEoe8BLm8lpm2kruIEv4=";

  meta = {
    description = "CLI tool for managing Satisfactory mods";
    homepage = "https://github.com/satisfactorymodding/ficsit-cli";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      weirdrock
      vilsol
    ];
    mainProgram = "ficsit-cli";
  };
}
