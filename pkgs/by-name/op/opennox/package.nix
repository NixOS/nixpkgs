{
  lib,
  stdenv,
  fetchFromGitHub,

  pkgsi686Linux,
  buildGoModule,
  SDL2,
  openal,

  pkg-config,
  writableDirWrapper,
  makeDesktopItem,
  copyDesktopItems,
  nox-assets,

  nix-update-script,

  pname ? "opennox",
  desktopName ? "OpenNox",
  extraDescription ? "",
  tags ? [ ],
}:
let
  # OpenNox can't compile under x86_64 :(
  deps_32bit =
    if (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86) then
      { inherit (pkgsi686Linux) buildGoModule SDL2 openal; }
    else
      { inherit buildGoModule SDL2 openal; };

  isWindowsClient = (!lib.elem "server" tags) && stdenv.hostPlatform.isWindows;

  fqpn = "io.github.noxworld_dev.OpenNox";

  version = "1.9.0-alpha13";

  src = fetchFromGitHub {
    owner = "opennox";
    repo = "opennox";
    rev = "refs/tags/v${version}";
    hash = "sha256-EfAYu2ZTBoFbroK5OLPftuSV91QhBNARpDULMayEOjg=";
  };

  description =
    "Modern implementation of the Nox game engine"
    + lib.optionalString (extraDescription != "") " (${extraDescription})";

  dataDir = "\${XDG_DATA_HOME:-$HOME/.local/share}/opennox";
  logDir = "\${XDG_STATE_HOME:-$HOME/.local/state}/opennox";
in
deps_32bit.buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-kkaC/SrpdXzGLA4KdJT0uWZLk6/Zzmys9rnc/U8py4Q=";

  nativeBuildInputs = [
    pkg-config
    writableDirWrapper
    copyDesktopItems
  ];

  buildInputs = [
    deps_32bit.SDL2
    deps_32bit.openal
  ];

  modRoot = "src";
  subPackages = [ "cmd/opennox" ];

  tags = tags ++ lib.optional isWindowsClient "guiapp";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/noxworld-dev/opennox/v1/internal/version.commit=${src.rev}"
    "-X github.com/noxworld-dev/opennox/v1/internal/version.version=v${version}"
  ] ++ lib.optional isWindowsClient "-H windowsgui";

  env = {
    CGO_CFLAGS_ALLOW = lib.concatMapStringsSep "|" (f: "(-f${f})") [
      "short-wchar"
      "no-strict-aliasing"
      "no-strict-overflow"
    ];
    CGO_CFLAGS = "-Wno-format-security";
  };

  # Requires gamedata.bin
  doCheck = false;

  desktopItems = [
    (makeDesktopItem {
      name = fqpn;
      exec = pname;
      comment = description;
      icon = fqpn;
      inherit desktopName;
      terminal = false;
      categories = [
        "Game"
        "ActionGame"
        "RolePlaying"
      ];
    })
  ];

  postInstall = ''
    install -Dm644 ../app/${fqpn}.metainfo.xml -t $out/share/metainfo
    install -Dm644 ../res/opennox_256.png $out/share/icons/hicolor/256x256/apps/${fqpn}.png
    install -Dm644 ../res/opennox_512.png $out/share/icons/hicolor/512x512/apps/${fqpn}.png
  '';

  postFixup = ''
    wrapProgramInWritableDir $out/bin/opennox '${dataDir}' \
      --add-flags '--data ${dataDir} --logs ${logDir}' \
      --link ${nox-assets} .
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://opennox.github.io/docs/";
    changelog = "https://opennox.github.io/docs/opennox/releases/index.html";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = pname;
    platforms = lib.intersectLists lib.platforms.x86 (lib.platforms.linux ++ lib.platforms.windows);
  };
}
