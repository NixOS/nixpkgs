{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  stdenv,
  autoreconfHook,
  pkg-config,
  ncurses,
  darwin,
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
  version = "unstable-2023-02-16";

  src = fetchFromGitHub {
    owner = "KoffeinFlummi";
    repo = pname;
    rev = "b2b58f8f152343b70c33b79ba51a298024278621";
    hash = "sha256-ZfdBAlnjoy8g6xwrR/i2+dGldMOfLlX6DRlNqB8pkGM=";
  };

  patches = [
    # See https://github.com/htop-dev/htop/pull/1412
    # Remove when updating to 3.4.0
    (fetchpatch2 {
      name = "htop-resolve-configuration-path.patch";
      url = "https://github.com/htop-dev/htop/commit/0dac8e7d38ec3aeae901a987717b5177986197e4.patch";
      hash = "sha256-Er1d/yV1fioYfEmXNlLO5ayAyXkyy+IaGSx1KWXvlv0=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ] ++ lib.optional stdenv.hostPlatform.isLinux pkg-config;

  buildInputs =
    [ ncurses ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.IOKit ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
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
    homepage = "https://github.com/KoffeinFlummi/htop-vim";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ thiagokokada ];
    mainProgram = "htop";
  };
}
