{
  lib,
  autoreconfHook,
  darwin,
  fetchFromGitHub,
  libcap,
  libnl,
  lm_sensors,
  ncurses,
  pkg-config,
  stdenv,
  systemd,
  sensorsSupport ? stdenv.isLinux,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

let
  inherit (darwin) IOKit;
in
assert systemdSupport -> stdenv.isLinux;
stdenv.mkDerivation rec {
  pname = "htop";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "htop-dev";
    repo = "htop";
    rev = version;
    hash = "sha256-qDhQkzY2zj2yxbgFUXwE0MGEgAFOsAhnapUuetO9WTw=";
  };

  nativeBuildInputs = [ autoreconfHook ] ++ lib.optional stdenv.isLinux pkg-config;

  buildInputs =
    [ ncurses ]
    ++ lib.optional stdenv.isDarwin IOKit
    ++ lib.optionals stdenv.isLinux [
      libcap
      libnl
    ]
    ++ lib.optional sensorsSupport lm_sensors
    ++ lib.optional systemdSupport systemd;

  configureFlags =
    [
      "--enable-unicode"
      "--sysconfdir=/etc"
    ]
    ++ lib.optionals stdenv.isLinux [
      "--enable-affinity"
      "--enable-capabilities"
      "--enable-delayacct"
    ]
    ++ lib.optional sensorsSupport "--enable-sensors";

  postFixup =
    let
      optionalPatch = pred: so: lib.optionalString pred "patchelf --add-needed ${so} $out/bin/htop";
    in
    lib.optionalString (!stdenv.hostPlatform.isStatic) ''
      ${optionalPatch sensorsSupport "${lm_sensors}/lib/libsensors.so"}
      ${optionalPatch systemdSupport "${systemd}/lib/libsystemd.so"}
    '';

  meta = {
    description = "Interactive process viewer";
    homepage = "https://htop.dev";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      relrod
      SuperSandro2000
    ];
    changelog = "https://github.com/htop-dev/htop/blob/main/ChangeLog";
    mainProgram = "htop";
  };
}
