{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  pkg-config,
  alsa-lib,
  curl,
  gtkmm3,
  libhandy,
  libopus,
  libpulseaudio,
  libsecret,
  libsodium,
  nlohmann_json,
  pcre2,
  spdlog,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "abaddon";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "uowuo";
    repo = "abaddon";
    tag = "v${version}";
    hash = "sha256-gvb60Qezf4zAFXIAmPVxZMcoturusYIDYu7v0r4heUA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    curl
    gtkmm3
    libhandy
    libopus
    libsecret
    libsodium
    nlohmann_json
    pcre2
    spdlog
    sqlite
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/abaddon
    cp -r ../res/{css,res} $out/share/abaddon
    mkdir $out/bin
    cp abaddon $out/bin
    wrapProgram $out/bin/abaddon \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          alsa-lib
          libpulseaudio
        ]
      }" \
      --chdir $out/share/abaddon

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      desktopName = "Abaddon";
      genericName = meta.description;
      startupWMClass = pname;
      categories = [
        "Network"
        "InstantMessaging"
      ];
      mimeTypes = [ "x-scheme-handler/discord" ];
    })
  ];

  meta = {
    description = "Discord client reimplementation, written in C++";
    mainProgram = "abaddon";
    homepage = "https://github.com/uowuo/abaddon";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
