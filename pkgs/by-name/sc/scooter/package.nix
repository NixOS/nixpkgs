{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "scooter";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "thomasschafer";
    repo = "scooter";
    rev = "v${version}";
    hash = "sha256-/wl6xbAXfPUTSI38htgkWC3IlsxtFbPOpBHqcSVBGPk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-kPweKXAitvODNoKTr2iB+qM9qMWGoKEQCxpkgrpnewY=";

  # Many tests require filesystem writes which fail in Nix sandbox
  doCheck = false;

  meta = {
    description = "Interactive find and replace in the terminal";
    homepage = "https://github.com/thomasschafer/scooter";
    changelog = "https://github.com/thomasschafer/scooter/commits/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixzieger ];
    mainProgram = "scooter";
  };
}
