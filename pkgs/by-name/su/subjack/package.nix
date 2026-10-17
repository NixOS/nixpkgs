{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "subjack";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "haccer";
    repo = "subjack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EVRNNPlDu1OxNU+bUUN90bH/Cg/YSR/ocIDEn3focT0=";
  };

  vendorHash = "sha256-AN+VEY+mrwf4mFTL2gdyr7zVnYgoCc719hUkuMVyzVw=";

  __structuredAttrs = true;

  meta = {
    description = "DNS Takeover Scanner written in Go";
    mainProgram = "subjack";
    homepage = "https://github.com/haccer/subjack";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fxai ];
  };
})
