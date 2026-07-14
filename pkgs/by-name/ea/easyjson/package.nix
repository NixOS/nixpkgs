{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "easyjson";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "mailru";
    repo = "easyjson";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6QfPxh3Kx9d2a93LsIehgjwkSDMGR8VuSzk58mblvTo=";
  };
  vendorHash = "sha256-BsksTYmfPQezbWfIWX0NhuMbH4VvktrEx06C2Nb/FYE=";

  subPackages = [ "easyjson" ];

  meta = {
    homepage = "https://github.com/mailru/easyjson";
    description = "Fast JSON serializer for Go";
    mainProgram = "easyjson";
    license = lib.licenses.mit;
  };
})
