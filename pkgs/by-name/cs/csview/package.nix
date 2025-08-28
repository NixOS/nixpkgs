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
    repo = "csview";
    rev = "v${version}";
    sha256 = "sha256-JFuqaGwCSfEIncBgLu6gGaOvAC5vojKFjruWcuSghS0=";
  };

  cargoHash = "sha256-CXIfE1EsNwm4vsybQSdfKewBYpzBh+uQu1jYAm8DDtI=";

  meta = with lib; {
    description = "High performance csv viewer with cjk/emoji support";
    mainProgram = "csview";
    homepage = "https://github.com/wfxr/csview";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
