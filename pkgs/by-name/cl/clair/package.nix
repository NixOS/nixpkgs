{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  rpm,
  xz,
}:

buildGoModule (finalAttrs: {
  pname = "clair";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "quay";
    repo = "clair";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YZ2r9hzTvsyTFqlXGcmdABtNuBkKclPLmDfMl5/vCug=";
  };

  vendorHash = "sha256-W9ITDut+/QpFMO+c7fNHBfL83bD7ILBEMsF2G9kPYwQ=";

  nativeBuildInputs = [
    makeWrapper
  ];

  subPackages = [
    "cmd/clair"
    "cmd/clairctl"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/clair \
      --prefix PATH : "${
        lib.makeBinPath [
          rpm
          xz
        ]
      }"
  '';

  meta = {
    description = "Vulnerability Static Analysis for Containers";
    homepage = "https://github.com/quay/clair";
    changelog = "https://github.com/quay/clair/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
