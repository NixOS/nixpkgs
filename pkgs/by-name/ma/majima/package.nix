{
  lib,
  fetchFromSourcehut,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "majima";
  version = "0.5.0";

  src = fetchFromSourcehut {
    owner = "~cucumber-zoom";
    repo = "majima";
    rev = "0f32dceeaf09c082cf33ab31b40d3bfc45aaa6f8";
    hash = "sha256-P5E0Wiy3mNPRCQ/bsIW4fG7LnPSPRXmW7pnbgl0/lBQ=";
  };

  cargoHash = "sha256-sblSlmXkiJkVGbrMU6HgtvYnAd48SlUOgDwB6ASMFsQ=";

  meta = with lib; {
    description = "Generate random usernames quickly and in various formats";
    homepage = "https://majima.matte.fyi/";
    license = licenses.mit;
    maintainers = [ maintainers.ufUNnxagpM ];
    mainProgram = "majima";
  };
}
