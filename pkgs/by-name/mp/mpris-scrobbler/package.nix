{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  curl,
  dbus,
  libevent,
  m4,
  meson,
  ninja,
  pkg-config,
  scdoc,
  json_c,
  xdg-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpris-scrobbler";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "mariusor";
    repo = "mpris-scrobbler";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Ro2Eop4CGvcT1hiCYxxmECFp5oefmAnBT9twnVfpsvY=";
  };

  postPatch = ''
    substituteInPlace src/signon.c \
      --replace "/usr/bin/xdg-open" "${xdg-utils}/bin/xdg-open"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace meson.build \
      --replace "-Werror=format-truncation=0" "" \
      --replace "-Wno-stringop-overflow" ""
  '';

  nativeBuildInputs = [
    m4
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    curl
    dbus
    json_c
    libevent
  ];

  mesonFlags = [
    "-Dversion=${finalAttrs.version}"
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    [
      # Needed with GCC 12
      "-Wno-error=address"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-Wno-sometimes-uninitialized"
      "-Wno-tautological-pointer-compare"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "-Wno-array-bounds"
      "-Wno-free-nonheap-object"
      "-Wno-stringop-truncation"
    ]
  );

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Minimalistic scrobbler for ListenBrainz, libre.fm, & last.fm";
    homepage = "https://github.com/mariusor/mpris-scrobbler";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emantor ];
    platforms = lib.platforms.unix;
    mainProgram = "mpris-scrobbler";
  };
})
