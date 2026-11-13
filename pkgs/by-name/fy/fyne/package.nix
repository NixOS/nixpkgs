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
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "fyne-io";
    repo = "tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NY0YfqvM1JMtlYnO/yzQK4CsNPnmPigTMdNJ7bA4QWI=";
  };

  vendorHash = "sha256-brLtfcKdsUg/X39ARPwbk/5QJQyOBUL2a7W2mvD9dtw=";

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
    maintainers = with lib.maintainers; [
      greg
      graysontinker
    ];
    mainProgram = "fyne";
  };
})
