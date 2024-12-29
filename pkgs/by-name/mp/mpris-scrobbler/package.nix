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

stdenv.mkDerivation rec {
  pname = "mpris-scrobbler";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "mariusor";
    repo = "mpris-scrobbler";
    rev = "v${version}";
    sha256 = "sha256-eeOhFkLyx+smZmKPTbVB1OiYkHdWk5v2rnOb9yCIuYE=";
  };

  postPatch =
    ''
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
    "-Dversion=${version}"
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

  meta = with lib; {
    description = "Minimalistic scrobbler for ListenBrainz, libre.fm, & last.fm";
    homepage = "https://github.com/mariusor/mpris-scrobbler";
    license = licenses.mit;
    maintainers = with maintainers; [ emantor ];
    platforms = platforms.unix;
    mainProgram = "mpris-scrobbler";
  };
}
