{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  argtable,
  enet,
  libconfuse,
  libepoxy,
  libpng,
  libxmp,
  SDL2,
  SDL2_mixer,
  unzip,
  zlib,
}:

let
  assets = fetchurl {
    url = "https://www.omf2097.com/pub/files/omf/omf2097-assets.zip";
    hash = "sha256-3kcseGrfnmGL9LcaXyy4W7CwkPJ9orMAjzBUU6jepn0=";
  };
  icons = fetchurl {
    url = "https://www.omf2097.com/pub/files/omf/openomf-icons.zip";
    hash = "sha256-8LWmrkY3ZiXcuVe0Zj90RQFUTwM27dJ4ev9TiBGoVk0=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openomf";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "omf2097";
    repo = "openomf";
    tag = finalAttrs.version;
    hash = "sha256-AMX905DEU+IeNIzMhyLYnaO9ESpzJo0nFrogSB4TxrQ=";
  };

  nativeBuildInputs = [
    cmake
    unzip
  ];

  buildInputs = [
    argtable
    enet
    libconfuse
    libepoxy
    libpng
    libxmp
    SDL2
    SDL2_mixer
    zlib
  ];

  postInstall =
    ''
      mkdir -p $out/share/icons/hicolor/256x256/apps
      unzip -j ${assets} -d $out/share/games/openomf
      unzip -p ${icons} omf-logo/omf-256x256.png > $out/share/icons/hicolor/256x256/apps/org.openomf.OpenOMF.png
      install -Dm644 $src/resources/flatpak/org.openomf.OpenOMF.desktop $out/share/applications/org.openomf.OpenOMF.desktop
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      ln -s $out/share/games/openomf/* $out/bin
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
