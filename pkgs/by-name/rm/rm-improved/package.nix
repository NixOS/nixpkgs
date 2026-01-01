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

  cargoHash = "sha256-jfrQkwJ6PcBs5W5F9x7Nt5xPP5f2G6MSb2AISu+g3gE=";

  cargoPatches = [
    # Cargo.lock out-of-date
    ./Cargo.lock.patch
  ];

<<<<<<< HEAD
  meta = {
    description = "Replacement for rm with focus on safety, ergonomics and performance";
    homepage = "https://github.com/nivekuil/rip";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ nils-degroot ];
=======
  meta = with lib; {
    description = "Replacement for rm with focus on safety, ergonomics and performance";
    homepage = "https://github.com/nivekuil/rip";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nils-degroot ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "rip";
  };
}
