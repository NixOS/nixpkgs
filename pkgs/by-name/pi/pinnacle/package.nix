{
  rustPlatform,
  lib,
  pkg-config,
  wayland,
  lua54Packages,
  lua5_4,
  extraLuaPackages ? (ps: [ ]),
  protobuf,
  seatd,
  systemdLibs,
  libxkbcommon,
  mesa,
  xwayland,
  libinput,
  libdisplay-info,
  git,
  libgbm,
  rustc,
  cargo,
  makeWrapper,
  callPackage,
  libglvnd,
  autoPatchelfHook,
  libxcursor,
  libxi,
  libxrandr,
  libx11,
  fetchFromGitHub,
}:
let
  version = "0.2.3";
  pinnacle-src = fetchFromGitHub {
    owner = "pinnacle-comp";
    repo = "pinnacle";
    tag = "v${version}";
    sha256 = "sha256-Ox7FspxwYrb4pMp4WGfw5NLhQqEp7X5gKv0pwDOs5z0=";
  };
  buildRustConfig = callPackage ./pinnacle-config.nix { inherit pinnacle-src; };

  meta = {
    description = "A WIP Smithay-based Wayland compositor, inspired by AwesomeWM and configured in Lua or Rust";
    homepage = "https://pinnacle-comp.github.io/pinnacle/";
    license = lib.licenses.gpl3;
    mainProgram = "pinnacle";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ cassandracomar ];
  };

  lua-client-api = lua54Packages.buildLuarocksPackage rec {
    inherit meta version;
    pname = "pinnacle-client-api";
    src = pinnacle-src;
    sourceRoot = "${src.name}/api/lua";
    knownRockspec = "${pinnacle-src}/api/lua/rockspecs/pinnacle-api-0.2.2-1.rockspec";
    propagatedBuildInputs = with lua54Packages; [
      cqueues
      http
      lua-protobuf
      compat53
      luaposix
    ];

    postInstall = ''
      mkdir -p $out/share/pinnacle/protobuf/pinnacle
      cp -rL --no-preserve ownership,mode ../../api/protobuf/pinnacle $out/share/pinnacle/protobuf
      mkdir -p $out/share/pinnacle/snowcap/protobuf/snowcap
      cp -rL --no-preserve ownership,mode ../../snowcap/api/protobuf/snowcap $out/share/pinnacle/snowcap/protobuf
      mkdir -p $out/share/pinnacle/protobuf/google
      cp -rL --no-preserve ownership,mode ../../api/protobuf/google $out/share/pinnacle/protobuf
      mkdir -p $out/share/pinnacle/snowcap/protobuf/google
      cp -rL --no-preserve ownership,mode ../../snowcap/api/protobuf/google $out/share/pinnacle/snowcap/protobuf
    '';
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  inherit meta version;

  pname = "pinnacle-server";
  src = pinnacle-src;
  cargoHash = "sha256-fJBmQmAK5XAcX8W5UuQIwfw0TM0RwrE2+Gmc0YL+i0o=";

  buildInputs = [
    wayland

    # libs
    seatd.dev
    systemdLibs.dev
    libxkbcommon
    libinput
    mesa
    xwayland
    libdisplay-info
    libgbm
    lua5_4

    # winit on x11
    libxcursor
    libxrandr
    libxi
    libx11
  ];

  nativeBuildInputs = [
    pkg-config
    protobuf
    lua54Packages.luarocks
    lua5_4
    lua-client-api
    git
    wayland
    makeWrapper
    autoPatchelfHook
  ];

  checkFeatures = [ "testing" ];
  checkNoDefaultFeatures = true;
  cargoTestFlags = [
    "--exclude"
    "wlcs_pinnacle"
    "--all"
    "--"
    "--skip"
    "process_spawn"
  ];

  preCheck = ''
    export LD_LIBRARY_PATH="${lib.makeLibraryPath [ wayland ]}";
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  postInstall = ''
    wrapProgram $out/bin/pinnacle --prefix PATH ":" ${
      lib.makeBinPath [
        rustc
        cargo
        finalAttrs.passthru.luaEnv
        xwayland
      ]
    }
    install -m755 ./resources/pinnacle-session $out/bin/pinnacle-session
    mkdir -p $out/share/wayland-sessions
    install -m644 ./resources/pinnacle.desktop $out/share/wayland-sessions/pinnacle.desktop
    patchShebangs $out/bin/pinnacle-session
    mkdir -p $out/share/xdg-desktop-portal
    install -m644 ./resources/pinnacle-portals.conf $out/share/xdg-desktop-portal/pinnacle-portals.conf
    install -m644 ./resources/pinnacle-portals.conf $out/share/xdg-desktop-portal/pinnacle-uwsm-portals.conf
  '';

  runtimeDependencies = [
    wayland
    mesa
    libglvnd # libEGL
  ];

  passthru = {
    luaEnv = lua5_4.withPackages (
      ps:
      [
        finalAttrs.passthru.lua-client-api
        ps.cjson
      ]
      ++ (extraLuaPackages ps)
    );
    inherit buildRustConfig;
    providedSessions = [ "pinnacle" ];
    lua-client-api = lua-client-api;
  };
})
