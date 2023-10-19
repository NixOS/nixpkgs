{ lib
, fetchFromGitHub
, stdenv
, cmake
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, pkg-config
, curl
, gtkmm3
, libhandy
, libopus
, libsecret
, libsodium
, nlohmann_json
, pcre2
, spdlog
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "abaddon";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "uowuo";
    repo = "abaddon";
    rev = "v${version}";
    hash = "sha256-Rz3c6RMZUiKQ0YKKQkCEkelfIGUq+xVmgNskj7uEjGI=";
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
      categories = [ "Network" "InstantMessaging" ];
      mimeTypes = [ "x-scheme-handler/discord" ];
    })
  ];

  meta = with lib; {
    description = "A discord client reimplementation, written in C++";
    homepage = "https://github.com/uowuo/abaddon";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ genericnerdyusername ];
    platforms = lib.intersectLists lib.platforms.x86_64 lib.platforms.linux;
  };
}
