{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  SDL2,
  SDL2_mixer,
  cmake,
  enet,
  libconfuse,
  libepoxy,
  libnatpmp,
  libpng,
  libxmp,
  miniupnpc,
  nix-update-script,
  opusfile,
  unzip,
  versionCheckHook,
  zlib,
}:

let
  assets = fetchurl {
    url = "https://www.omf2097.com/pub/files/omf/openomf-assets.zip";
    hash = "sha256-3kcseGrfnmGL9LcaXyy4W7CwkPJ9orMAjzBUU6jepn0=";
  };
  icons = fetchurl {
    url = "https://www.omf2097.com/pub/files/omf/openomf-icons.zip";
    hash = "sha256-nsmM1daT2IKh8DIai9EzulhPFXTOCedXpKt4qvbR3w4=";
  };
  musicRemixes = fetchurl {
    url = "https://github.com/omf2097/openomf-music-mod/releases/download/1.0/openomf-mods-1.0.zip";
    hash = "sha256-uiaM6n+dDcTeBNNnypEWXPNG8Xac1JQXCTfVkORfvi0=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openomf";
  version = "0.8.6";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "omf2097";
    repo = "openomf";
    tag = finalAttrs.version;
    hash = "sha256-KzT2leU52nxUIsuiVM5soWmi+x1LStdxY5JLoCkSSb8=";
  };

  postPatch = ''
    # TODO: Take this upstream
    substituteInPlace cmake-scripts/version.cmake \
      --replace-fail "set(VERSION_MAJOR 0)" "set(VERSION_MAJOR ${lib.versions.major finalAttrs.version})" \
      --replace-fail "set(VERSION_MINOR 0)" "set(VERSION_MINOR ${lib.versions.minor finalAttrs.version})" \
      --replace-fail "set(VERSION_PATCH 0)" "set(VERSION_PATCH ${lib.versions.patch finalAttrs.version})" \
      --replace-fail "set(VERSION_LABEL)" "set(VERSION_LABEL)
      return()"

    substituteInPlace src/resources/resource_paths.c \
      --replace-fail \
        "/usr/local/share/games:/usr/share/games:/usr/local/share:/usr/share" \
        "$out/share/games"
  '';

  nativeBuildInputs = [
    cmake
    unzip
  ];

  buildInputs = [
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
    unzip -j ${assets} -d $out/share/games/openomf/resources

    unzip ${musicRemixes} -d $out/share/games/openomf/mods

    unzip -j ${icons} -d icons
    for size in 48 64 128 256; do
      install -Dm644 icons/omf-''${size}x''${size}.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/org.openomf.OpenOMF.png
    done

    install -Dm644 $src/resources/flatpak/org.openomf.OpenOMF.desktop -t $out/share/applications
    install -Dm644 $src/resources/flatpak/org.openomf.OpenOMF.metainfo.xml -t $out/share/metainfo
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "One Must Fall 2097 Remake";
    longDescription = ''
      OpenOMF is an open-source remake of the 1994 DOS fighting game One Must
      Fall 2097 by Diversions Entertainment. It reimplements the original
      engine from scratch, uses the original (now freeware) game assets, and
      adds modern conveniences such as online netplay.

      Includes remixed music mod. To add other mods: drop its .zip file
      into the user mods directory as-is; it does not need to be extracted.

      The user mods directory is <state>/mods, where <state> is resolved at
      launch in the following order.

        1. $OPENOMF_STATE_PATH, if set
        2. $XDG_STATE_HOME, if set
           (e.g. ~/.local/state, giving ~/.local/state/mods)
        3. SDL's preference path, ~/.local/share/OpenOMF/mods
    '';
    homepage = "https://www.openomf.org";
    changelog = "https://github.com/omf2097/openomf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.all;
    mainProgram = "openomf";
  };
})
