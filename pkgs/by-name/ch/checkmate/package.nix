{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "checkmate";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = "checkmate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-R4gzykT44AbcuU4lFbZuEjL9vUZpDtXZy4HNs48nlms=";
  };

  vendorHash = "sha256-D2ifIakC/j6M5mqV/ZlgNSUBlfMnc21GjHWovbOkDfs=";

  subPackages = [ "." ];

  meta = {
    description = "Pluggable code security analysis tool";
    mainProgram = "checkmate";
    homepage = "https://github.com/adedayo/checkmate";
    changelog = "https://github.com/adedayo/checkmate/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
