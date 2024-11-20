{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  makeWrapper,
}:
let
  pname = "gitopper";
  version = "0.0.16";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "miekg";
    repo = "gitopper";
    rev = "v${version}";
    hash = "sha256-EAOC54VtGx6axfty5m8JOebcayINTy4cP4NBo5+ioLk=";
  };

  ldflags = [ "-X main.Version=${version}" ];

  vendorHash = "sha256-sxeN7nbNTGfD8ZgNQiEQdYl11rhOvPP8UrnYXs9Ljhc=";

  nativeCheckInputs = [
    makeWrapper
    git
  ];

  checkFlags =
    let
      # Skip tests that does not works well inside an isolated environment
      skippedTests = [
        "TestInitialGitCheckout"
        "TestHash"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    wrapProgram $out/bin/gitopper \
      --suffix PATH : ${lib.makeBinPath [ git ]}
  '';

  meta = {
    description = "Gitops for non-Kubernetes folks";
    homepage = "https://github.com/miekg/gitopper/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "gitopper";
  };
}
