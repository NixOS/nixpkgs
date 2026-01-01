{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "atlantis";
<<<<<<< HEAD
  version = "0.38.0";
=======
  version = "0.37.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-5V+2MgVcxq3DtMkBeA64mUaSL3zYG/+c1SbChaRbQ98=";
=======
    hash = "sha256-Dv9vf4Ye5LEwJ19RW7wJUgAAPLDtRIAoZt0xTsxODYg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  ldflags = [
    "-X=main.version=${finalAttrs.version}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

<<<<<<< HEAD
  vendorHash = "sha256-bdZn2cNSpmV1nngQWBFkf2G0uxlJF1UX50oMZYU7+i0=";
=======
  vendorHash = "sha256-ZJF+Q5SFn92mUMm7HhK5WyRYTvJEYThnSbv1FPeI4hk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "." ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/atlantis";
  versionCheckProgramArg = "version";

  meta = {
    homepage = "https://github.com/runatlantis/atlantis";
    description = "Terraform Pull Request Automation";
    mainProgram = "atlantis";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
