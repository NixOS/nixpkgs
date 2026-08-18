{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  sqlite,
  zlib,
  wayland,
}:

let
  libwifi = fetchFromGitHub {
    owner = "Ragnt";
    repo = "libwifi";
    rev = "71268e1898ad88b8b5d709e186836db417b33e81";
    hash = "sha256-2X/TZyLX9Tb54c6Sdla4bsWdq05NU72MVSuPvNfxySk=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "angryoxide";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "Ragnt";
    repo = "AngryOxide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OMNpAp+SmwFlNFlsL3DVgUYja+4o26B7AbR8JMz/4JA=";
  };

  postPatch = ''
    rm -r libs/libwifi
    ln -s ${libwifi} libs/libwifi
  '';

  cargoHash = "sha256-dktJEcX4IbhwDyfptA6PZaAcvF6RRC+jWTspnHaof4s=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
    sqlite
    wayland
    zlib
  ];

  meta = {
    description = "802.11 Attack Tool";
    changelog = "https://github.com/Ragnt/AngryOxide/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/Ragnt/AngryOxide/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fvckgrimm ];
    mainProgram = "angryoxide";
    platforms = lib.platforms.linux;
  };
})
