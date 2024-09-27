{
  lib,
  autoreconfHook,
  curl,
  fetchFromGitHub,
  installShellFiles,
  ldc,
  libnotify,
  pkg-config,
  sqlite,
  stdenv,
  systemd,
  testers,
  # Boolean flags
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "onedrive";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "abraunegg";
    repo = "onedrive";
    rev = "v${finalAttrs.version}";
    hash = "sha256-up7o1myrQutDOEX98rkMlxJZs+Wzaf9HkOYNsX/JC4s=";
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
    libnotify
    sqlite
  ] ++ lib.optionals withSystemd [ systemd ];

  configureFlags = [
    (lib.enableFeature true "notifications")
    (lib.withFeatureAs withSystemd "systemdsystemunitdir" "${placeholder "out"}/lib/systemd/system")
    (lib.withFeatureAs withSystemd "systemduserunitdir" "${placeholder "out"}/lib/systemd/user")
  ];

  # we could also pass --enable-completions to configure but we would then have to
  # figure out the paths manually and pass those along.
  postInstall = ''
    installShellCompletion --bash --name onedrive contrib/completions/complete.bash
    installShellCompletion --fish --name onedrive contrib/completions/complete.fish
    installShellCompletion --zsh --name _onedrive contrib/completions/complete.zsh
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
      AndersonTorres
      peterhoeg
      bertof
    ];
    platforms = lib.platforms.linux;
  };
})
