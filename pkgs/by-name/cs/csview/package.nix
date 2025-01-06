{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "csview";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JFuqaGwCSfEIncBgLu6gGaOvAC5vojKFjruWcuSghS0=";
  };

  cargoHash = "sha256-mH1YpuYahdHFS+1cK9dryHbUqjewdbkNGxRBUOd2Hws=";

  meta = {
    description = "High performance csv viewer with cjk/emoji support";
    mainProgram = "csview";
    homepage = "https://github.com/wfxr/csview";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
