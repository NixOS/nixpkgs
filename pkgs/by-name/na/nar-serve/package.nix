{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "nar-serve";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "nar-serve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nbB5eduYl72HGvOXqS/0mnAi2hxvrak7j457baAvqJo=";
  };

  vendorHash = "sha256-82uMrkvqsUaSvEi0mlGBOAP9JCLABsHsHsikrrCknWY=";

  doCheck = false;

  passthru.tests = { inherit (nixosTests) nar-serve; };

  meta = {
    description = "Serve NAR file contents via HTTP";
    mainProgram = "nar-serve";
    homepage = "https://github.com/numtide/nar-serve";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      rizary
      zimbatm
    ];
  };
})
