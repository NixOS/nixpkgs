{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "efmt";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "sile";
    repo = "efmt";
    rev = version;
    hash = "sha256-cRiYOJiBIRHm9s3EFhRNTvLXw66Svu1vc4ipWYKDo1s=";
  };

  cargoHash = "sha256-Wb8SNPsubhVyfIzcPjkqauforLmhNlfas4KwD/l40sI=";

  meta = {
    description = "Erlang code formatter";
    homepage = "https://github.com/sile/efmt";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ haruki7049 ];
    mainProgram = "efmt";
  };
}
