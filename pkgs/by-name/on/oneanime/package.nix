{
  lib,
  fetchFromGitHub,
  flutter324,
  autoPatchelfHook,
  wrapGAppsHook3,
  makeDesktopItem,
  pkg-config,
  copyDesktopItems,
  alsa-lib,
  libepoxy,
  libpulseaudio,
  libdrm,
  mesa,
  xdg-user-dirs,
  libva,
  libva1,
  libvdpau,
  buildGoModule,
}:
let
  libopencc = buildGoModule rec {
    pname = "libopencc";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "Predidit";
      repo = "open_chinese_convert_bridge";
      rev = "refs/tags/${version}";
      hash = "sha256-kC5+rIBOcwn9POvQlKEzuYKKcbhuqVs+pFd4JSFgINQ=";
    };

    vendorHash = "sha256-ADODygC9VRCdeuxnkK4396yBny/ClRUdG3zAujPzpOM=";

    buildPhase = ''
      runHook preBuild

      go build -buildmode=c-shared -o ./libopencc.so

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm0755 ./libopencc.so $out/lib/libopencc.so

      runHook postInstall
    '';

    meta = {
      homepage = "https://github.com/Predidit/open_chinese_convert_bridge";
      license = with lib.licenses; [ gpl3Plus ];
      maintainers = with lib.maintainers; [ aucub ];
    };
  };
in
flutter324.buildFlutterApplication rec {
  pname = "oneanime";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "Predidit";
    repo = "oneAnime";
    rev = "refs/tags/${version}";
    hash = "sha256-CespZRb2JDc6FltEdibBOFd9BmkWGT8RSMbOC7cuA18=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  desktopItems = [
    (makeDesktopItem {
      name = "oneanime";
      exec = "oneanime";
      icon = "oneanime";
      desktopName = "oneAnime";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    libepoxy
    libpulseaudio
    libdrm
    mesa
  ];

  postPatch = ''
    substituteInPlace lib/pages/init_page.dart \
      --replace-fail "lib/opencc.so" "${libopencc}/lib/libopencc.so"
  '';

  postInstall = ''
    install -Dm0644 ./assets/images/logo/logo_android_2.png  $out/share/pixmaps/oneanime.png
    ln -s ${lib.getLib libva}/lib/libva.so.2 $out/app/${pname}/lib/libva.so.2
    ln -s ${lib.getLib libva1}/lib/libva.so.1 $out/app/${pname}/lib/libva.so.1
    ln -s ${lib.getLib libvdpau}/lib/libvdpau.so.1  $out/app/${pname}/lib/libvdpau.so.1
  '';

  extraWrapProgramArgs = ''
    --prefix PATH : ${lib.makeBinPath [ xdg-user-dirs ]}
  '';

  meta = {
    description = "Anime1 third-party client with bullet screen";
    homepage = "https://github.com/Predidit/oneAnime";
    mainProgram = "oneanime";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = [ "x86_64-linux" ]; # mdk-sdk of nixpkgs currently only has x64
  };
}
