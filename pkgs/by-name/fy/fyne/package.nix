{
  lib,
  buildGoModule,
  fetchFromGitHub,

  libGL,
  libx11,
  libxcursor,
  libxinerama,
  libxi,
  libxrandr,
  libxxf86vm,
  pkg-config,
}:

buildGoModule (finalAttrs: {
  pname = "fyne";
  # This is the current latest version
  # version "1.26.1" was a typo of "1.7.1" - maybe, don't "upgrade" to it
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "fyne-io";
    repo = "tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NmO0AtD2lJMBOnlgFm6dXRp6NWMuyAIlckYLHugeJ1Q=";
  };

  vendorHash = "sha256-pTVl9NMqoLqRYrNFWSoagpELwbsW7t5kHYo+fEFQie0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libGL
    libx11
    libxcursor
    libxinerama
    libxi
    libxrandr
    libxxf86vm
  ];

  doCheck = false;

  meta = {
    homepage = "https://fyne.io";
    description = "Cross platform GUI toolkit in Go";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ greg ];
    mainProgram = "fyne";
  };
})
