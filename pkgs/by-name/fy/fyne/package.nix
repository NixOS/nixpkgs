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
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "fyne-io";
    repo = "tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kLhh44zRYEPD6kwh+DHaRYidbV+YWq9Tc0yB3f290Z4=";
  };

  vendorHash = "sha256-EzwSZDq3s74ohGk0s9NV5RwSFqlUA5AFM8DvKSZeXnM=";

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
