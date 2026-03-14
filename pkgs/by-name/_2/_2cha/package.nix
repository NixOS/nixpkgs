{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "2cha";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "keepinfov";
    repo = "2cha";
    tag = "v${version}";
    sha256 = "sha256-NFV4VPn2b4fHHRtAOvNIcOnWaSf4J99prfdf38R2iSg=";
  };

  cargoHash = "sha256-84GRkTnGPXrYAbZq35I+C7isQ3dnXSv7meJf1Rvgrak=";

  meta = {
    description = "Minimalist VPN tool powered by ChaCha20-Poly1305 encryption";
    homepage = "https://github.com/keepinfov/2cha";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ keepinfov ];
    mainProgram = "2cha";
    platforms = lib.platforms.unix;
  };
}
