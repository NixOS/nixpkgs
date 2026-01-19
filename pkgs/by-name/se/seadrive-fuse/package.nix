{
  lib,
  stdenv,
  nix-update-script,
  fetchFromGitHub,
  autoreconfHook,
  curl,
  libargon2,
  libevent,
  libsearpc,
  libuuid,
  pkg-config,
  python3,
  sqlite,
  vala,
  libwebsockets,
  fuse,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "seadrive-fuse";
  version = "3.0.18";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seadrive-fuse";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oMi297ORIKdJhuYOvazJ+oSVCwRAqvjy0pc+lyBq5oQ=";
  };

  nativeBuildInputs = [
    libwebsockets
    autoreconfHook
    vala
    fuse
    pkg-config
    python3
  ];

  buildInputs = [
    libargon2
    libuuid
    sqlite
    libsearpc
    libevent
    curl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/haiwen/seadrive-fuse";
    description = "SeaDrive daemon with FUSE interface";
    changelog = "https://github.com/haiwen/seadrive-fuse/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      wenbin-liu
    ];
    mainProgram = "seadrive";
  };
})
