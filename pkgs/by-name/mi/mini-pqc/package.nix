{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mini-pqc";
  version = "0.1.5-unstable-2025-09-17";

  src = fetchFromGitHub {
    owner = "oferzinger";
    repo = "mini-pqc-scanner";
    rev = "c9c730397109f8a5a73201b4ba958aa437571279";
    hash = "sha256-l+Wu4iDjjupMY4EFRdZfy7mZ6n6eKFvv16bs89FG2o8=";
  };

  vendorHash = "sha256-UO22uxPV8fqGix/8Nx5mLIQl8Y7fWE8ze7fbtoAehJE=";

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/$pname
  '';

  meta = {
    description = "Command-line tool that helps to assess quantum readiness";
    homepage = "https://github.com/oferzinger/mini-pqc-scanner";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mini-pqc";
  };
})
