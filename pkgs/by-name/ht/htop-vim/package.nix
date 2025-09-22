{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  stdenv,
  autoreconfHook,
  pkg-config,
  ncurses,
  libcap,
  libnl,
  sensorsSupport ? stdenv.hostPlatform.isLinux,
  lm_sensors,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
}:

assert systemdSupport -> stdenv.hostPlatform.isLinux;

stdenv.mkDerivation rec {
  pname = "htop-vim";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "htop-dev";
    repo = "htop-vim";
    rev = version;
    hash = "sha256-4M2Kzy/tTpIZzpyubnXWywQh7Np5InT4sYkVG2v6wWs";
  };

  patches = [
    (fetchpatch2 {
      name = "vim-keybindings.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/vim-keybindings.patch?h=htop-vim&id=d10f022b3ca1207200187a55f5b116a5bd8224f7";
      hash = "sha256-fZDTA2dCOmXxUYD6Wm41q7TxL7fgQOj8a/8yJC7Zags=";
    })
  ];

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
  ++ lib.optional systemdSupport systemd;

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
      ${optionalPatch systemdSupport "${systemd}/lib/libsystemd.so"}
    '';

  meta = with lib; {
    description = "Interactive process viewer, with vim-style keybindings";
    homepage = "https://aur.archlinux.org/packages/htop-vim";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ thiagokokada ];
    mainProgram = "htop";
  };
}
