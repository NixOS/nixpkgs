{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "efmt";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "sile";
    repo = "efmt";
    rev = version;
    hash = "sha256-sS6OqcVuRZXGjrTv5gYz3ECrHNOsu/1eN7Jqs9QRm3Q=";
  };

  cargoHash = "sha256-gcgKOgWdQwSFN9WMTJ/PBob+iuAqG+yTrSnbevM+csI=";

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
