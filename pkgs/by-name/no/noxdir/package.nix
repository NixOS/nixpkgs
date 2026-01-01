{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "noxdir";
<<<<<<< HEAD
  version = "0.11.0";
=======
  version = "0.10.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "crumbyte";
    repo = "noxdir";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-V6tQ9ZERsbc4Hg/Yo5tkLPUu353m2Mu+kBYDuZ2fWCA=";
=======
    hash = "sha256-FC2+tXsFu8VWgvAqo+DWWII9c9YhURwzM86S4oU92ms=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-uRJP21bJ8NlJ0qOG81Gax9LJ+HdPfxLKj1Jjzbweync=";

  checkPhase = ''
    runHook preCheck
    go test -v -buildvcs -race ./...
    runHook postCheck
  '';

  meta = {
    description = "Terminal utility for visualizing file system usage";
    homepage = "https://github.com/crumbyte/noxdir";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ruiiiijiiiiang ];
    mainProgram = "noxdir";
  };
})
