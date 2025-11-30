{
  lib,
  fetchFromGitHub,
  stdenv,
  autoreconfHook,
  pkg-config,
  ncurses,
  libcap,
  libnl,
  sensorsSupport ? stdenv.hostPlatform.isLinux,
  lm_sensors,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
  systemdLibs,
}:

assert systemdSupport -> stdenv.hostPlatform.isLinux;

stdenv.mkDerivation rec {
  pname = "htop";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "htop-dev";
    repo = "htop";
    tag = version;
    hash = "sha256-fVqQwXbJus2IVE1Bzf3yJJpKK4qcZN/SCTX1XYkiHhU=";
  };

  # upstream removed pkg-config support and uses dlopen now
  postPatch =
    let
      libnlPath = lib.getLib libnl;
    in
    lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace configure.ac \
        --replace-fail /usr/include/libnl3 ${lib.getDev libnl}/include/libnl3
      substituteInPlace linux/LibNl.c \
        --replace-fail libnl-3.so ${libnlPath}/lib/libnl-3.so \
        --replace-fail libnl-genl-3.so ${libnlPath}/lib/libnl-genl-3.so
    '';

  nativeBuildInputs = [ autoreconfHook ] ++ lib.optional stdenv.hostPlatform.isLinux pkg-config;

  buildInputs = [
    ncurses
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap
    libnl
  ]
  ++ lib.optional sensorsSupport lm_sensors
  ++ lib.optional systemdSupport systemdLibs;

  configureFlags = [
    "--enable-unicode"
    "--sysconfdir=/etc"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
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
      ${optionalPatch sensorsSupport "${lib.getLib lm_sensors}/lib/libsensors.so"}
      ${optionalPatch systemdSupport "${systemdLibs}/lib/libsystemd.so"}
    '';

  meta = {
    description = "Interactive process viewer";
    homepage = "https://htop.dev";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      rob
      relrod
      SuperSandro2000
    ];
    changelog = "https://github.com/htop-dev/htop/blob/${version}/ChangeLog";
    mainProgram = "htop";
  };
}
