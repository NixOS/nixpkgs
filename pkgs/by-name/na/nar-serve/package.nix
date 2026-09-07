{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "nar-serve";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "nar-serve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-C9MBCN/ResbYjmRkT65m8XnNbquoZ0PC/zx/Y7QFXkA=";
  };

  vendorHash = "sha256-BP14jmOZ2MCugeTgbDR8wSZ8sRWt4QUWrH3+e2FBgqU=";

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
