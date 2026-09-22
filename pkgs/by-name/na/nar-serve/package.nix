{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "nar-serve";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "nar-serve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-72gY3V9XLi+qZWDH3ARR2DLEYC3cszYkAVBBBRTNcrM=";
  };

  vendorHash = "sha256-sms5yAbbc6PN02DFFRTktjaryDF/h+3b14BC+ZwMBOA=";

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
