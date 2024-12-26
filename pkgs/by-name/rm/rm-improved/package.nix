{
  fetchFromGitHub,
  rustPlatform,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "rm-improved";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "nivekuil";
    repo = "rip";
    rev = version;
    hash = "sha256-jbXmGPrb9PhmCSUFVcCqg8HjntS2mrYeNuaMsU+zIFI=";
  };

  cargoHash = "sha256-05ebuPa8N+hz5BnqAdOCL6dnBqVsB9VN4HxfwL99gK0=";

  cargoPatches = [
    # Cargo.lock out-of-date
    ./Cargo.lock.patch
  ];

  meta = with lib; {
    description = "Replacement for rm with focus on safety, ergonomics and performance";
    homepage = "https://github.com/nivekuil/rip";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nils-degroot ];
    mainProgram = "rip";
  };
}
