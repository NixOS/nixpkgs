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
  # version "1.26.1" was a typo of "1.7.0" - maybe, don't "upgrade" to it
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "fyne-io";
    repo = "tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x2OfiFn5VHE3OrlfSMUQY1mckdnCcDpq1vqLmRi6yAg=";
  };

  vendorHash = "sha256-J5JxKN0i5nbLTBgwZ5HJPFiqHd7yvP+YkyvPteD2xF0=";

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
