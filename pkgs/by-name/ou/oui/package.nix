{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "oui";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "thatmattlove";
    repo = "oui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RLm8V2fLFvOwjnnq16ZmhwVdtgXPaehan7JTX3Xz30w=";
  };

  vendorHash = "sha256-TLVw4tnfvgK2h/Xj5LNNjDG4WQ83Bw8yBhZc16Tjmws=";

  meta = {
    description = "MAC Address CLI Toolkit";
    homepage = "https://github.com/thatmattlove/oui";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ johannwagner ];
    mainProgram = "oui";
  };
})
