{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  testers,
  xorg,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "restish";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "danielgtaylor";
    repo = "restish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a0ObgFgWEsLYjGmCCi/py2PADAWJ0By+AZ4wh+Yeam4=";
  };

  vendorHash = "sha256-qeArar0WnMACUnKBlC+PcFeJPzofwbK440A4M/rQ04U=";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  passthru.tests.version =
    (testers.testVersion {
      package = finalAttrs.finalPackage;
    }).overrideAttrs
      (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ writableTmpDirAsHomeHook ];
      });

  meta = with lib; {
    description = "CLI tool for interacting with REST-ish HTTP APIs";
    homepage = "https://rest.sh/";
    changelog = "https://github.com/danielgtaylor/restish/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "restish";
  };
})
