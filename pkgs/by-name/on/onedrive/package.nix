{
  lib,
  stdenv,
  fetchFromGitHub,

  # native
  autoreconfHook,
  installShellFiles,
  ldc,
  pkg-config,

  # host
  coreutils,
  curl,
  dbus,
  libnotify,
  sqlite,
  systemd,
  testers,

  # Boolean flags
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "onedrive";
  version = "2.5.9";

  src = fetchFromGitHub {
    owner = "abraunegg";
    repo = "onedrive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vrr7KR4yMH+IZ56IUTp9eAhxEtiXx+ppleUd7jSLzxc=";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  nativeBuildInputs = [
    autoreconfHook
    installShellFiles
    ldc
    pkg-config
  ];

  buildInputs = [
    curl
    dbus
    libnotify
    sqlite
  ]
  ++ lib.optionals withSystemd [ systemd ];

  configureFlags = [
    (lib.enableFeature true "notifications")
    (lib.withFeatureAs withSystemd "systemdsystemunitdir" "${placeholder "out"}/lib/systemd/system")
    (lib.withFeatureAs withSystemd "systemduserunitdir" "${placeholder "out"}/lib/systemd/user")
  ];

  # we could also pass --enable-completions to configure but we would then have to
  # figure out the paths manually and pass those along.
  postInstall = ''
    installShellCompletion --cmd onedrive \
      --bash contrib/completions/complete.bash \
      --fish contrib/completions/complete.fish \
      --zsh contrib/completions/complete.zsh

    substituteInPlace $out/lib/systemd/user/onedrive.service $out/lib/systemd/system/onedrive@.service \
      --replace-fail "/bin/sh -c 'sleep 15'" "${coreutils}/bin/sleep 15"
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    homepage = "https://github.com/abraunegg/onedrive";
    description = "Complete tool to interact with OneDrive on Linux";
    license = lib.licenses.gpl3Only;
    mainProgram = "onedrive";
    maintainers = with lib.maintainers; [
      peterhoeg
      bertof
      guylamar2006
    ];
    platforms = lib.platforms.linux;
  };
})
