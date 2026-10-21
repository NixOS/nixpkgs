{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "errcheck";
  version = "1.30.0";

  src = fetchFromGitHub {
    owner = "kisielk";
    repo = "errcheck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3oap11vNjA7YZAFEkVTkZgXuJW5PRPvGkSYoAVo//8M=";
  };

  vendorHash = "sha256-sFcuL18a8Jw/e3qphOzrm/ORu8zJWY5B9refZCrCWeY=";

  subPackages = [ "." ];

  meta = {
    description = "Checks for unchecked errors in go programs";
    mainProgram = "errcheck";
    homepage = "https://github.com/kisielk/errcheck";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kalbasit ];
  };
})
