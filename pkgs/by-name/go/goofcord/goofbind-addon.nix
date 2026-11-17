{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libx11,
  libxtst,
  libxdmcp,
  libxkbfile,
  libxkbcommon,
  libxcb,
  wayland,
  xorgproto,
  libxi,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "goofbind";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "Milkshiift";
    repo = "goofbind";

    # Fetch commit from repo, until the tag version is released
    rev = "703237071f61d1ceede8076b0015488773a7c4ae";
    hash = "sha256-XAt0ThqDRPun5nrp1sFWEeX3vEIGOpXpwQsx1I4bfqA=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-GAtNCaMFAbgHktLU+/rQGfbjVEY4iFCmfuQw0y5wFcY=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    cmake
  ];

  buildInputs = [
    libx11
    libxtst
    libxdmcp
    libxkbfile
    libxkbcommon
    libxcb
    wayland
    libxi
    xorgproto
  ];

  doCheck = false;

  meta = {
    description = "Native module for Vencord";
    homepage = "https://github.com/tuxinal/venbind";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
})
