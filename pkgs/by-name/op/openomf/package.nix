{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  argtable,
  enet,
  git,
  libconfuse,
  libnatpmp,
  libepoxy,
  libpng,
  libxmp,
  miniupnpc,
  opusfile,
  SDL2,
  SDL2_mixer,
  unzip,
  zlib,
  withRemix ? true,
}:

let
  assets = fetchurl {
    url = "https://www.omf2097.com/pub/files/omf/openomf-assets.zip";
    hash = "sha256-3kcseGrfnmGL9LcaXyy4W7CwkPJ9orMAjzBUU6jepn0=";
  };
  icons = fetchurl {
    url = "https://www.omf2097.com/pub/files/omf/openomf-icons.zip";
    hash = "sha256-8LWmrkY3ZiXcuVe0Zj90RQFUTwM27dJ4ev9TiBGoVk0=";
  };
  remix = fetchurl {
    url = "https://github.com/omf2097/openomf/releases/download/0.8.0/ARENA2.ogg";
    hash = "sha256-jOIzDaIwQDlwCaPrRZdG5Y0g7bWKwc38mPKP030PGb4=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openomf";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "omf2097";
    repo = "openomf";
    tag = finalAttrs.version;
    hash = "sha256-5X8drQKMwYZ5M/i7hxyI25AysQGedQ5BLEYcNXWHgNk=";
  };

  nativeBuildInputs = [
    cmake
    git
    unzip
  ];

  buildInputs = [
    argtable
    enet
    libconfuse
    libepoxy
    libnatpmp
    libpng
    libxmp
    miniupnpc
    opusfile
    SDL2
    SDL2_mixer
    zlib
  ];

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/256x256/apps
    unzip -j ${assets} -d $out/share/games/openomf
    unzip -p ${icons} omf-logo/omf-256x256.png > $out/share/icons/hicolor/256x256/apps/org.openomf.OpenOMF.png
    install -Dm644 $src/resources/flatpak/org.openomf.OpenOMF.desktop $out/share/applications/org.openomf.OpenOMF.desktop
  ''
  + lib.optionalString withRemix ''
    ln -s ${remix} $out/share/games/openomf/ARENA2.ogg
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/resources
    ln -s $out/share/games/openomf/* $out/resources
  '';

  meta = {
    description = "One Must Fall 2097 Remake";
    homepage = "https://www.openomf.org";
    changelog = "https://github.com/omf2097/openomf/releases/tag/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "openomf";
    platforms = lib.platforms.all;
  };
})
