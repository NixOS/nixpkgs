{ lib, stdenv
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "sub-batch";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "kl";
    repo = pname;
    # Upstream doesn't tag releases.
    rev = "631bd6e2d931f8a8e12798f4b6460739a14bcfff";
    sha256 = "sha256-424e40v2LBxlmgDKxvsT/iuUn/IKWPKMwih0cSQ5sFE=";
  };

  cargoSha256 = "sha256-l+BTF9PGb8bG8QHhNCoBsrsVX8nlRjPlaea1ESFfMW0=";

  meta = with lib; {
    description = "Match and rename subtitle files to video files and perform other batch operations on subtitle files";
    homepage = "https://github.com/kl/sub-batch";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
    broken = stdenv.isDarwin;
  };
}
