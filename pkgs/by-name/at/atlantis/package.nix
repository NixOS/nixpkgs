{
  lib,
  bash,
  buildGoModule,
  git,
  makeWrapper,
  nixosTests,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "atlantis";
  version = "0.37.1";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Dv9vf4Ye5LEwJ19RW7wJUgAAPLDtRIAoZt0xTsxODYg=";
  };

  ldflags = [
    "-X=main.version=${finalAttrs.version}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  vendorHash = "sha256-ZJF+Q5SFn92mUMm7HhK5WyRYTvJEYThnSbv1FPeI4hk=";

  subPackages = [ "." ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/atlantis \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          git
        ]
      }
  '';
  versionCheckProgram = "${placeholder "out"}/bin/atlantis";
  versionCheckProgramArg = "version";

  passthru.tests = {
    inherit (nixosTests) atlantis;
  };

  meta = {
    homepage = "https://github.com/runatlantis/atlantis";
    description = "Terraform Pull Request Automation";
    mainProgram = "atlantis";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
