{
  lib,
  autoreconfHook,
  coreutils,
  curl,
  fetchFromGitHub,
  fetchpatch,
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
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "abraunegg";
    repo = "onedrive";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Lek1tW0alQQvlOHpz//M/y4iJY3PWRkcmXGLwjCLozk=";
  };

  patches = [
    # remove when updating to v2.5.4
    (fetchpatch {
      name = "fix-openssl-version-check-error.patch";
      url = "https://github.com/abraunegg/onedrive/commit/d956318b184dc119d65d7a230154df4097171a6d.patch";
      hash = "sha256-LGmKqYgFpG4MPFrHXqvlDp7Cxe3cEGYeXXH9pCXtGkU=";
    })
  ];

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

    substituteInPlace $out/lib/systemd/user/onedrive.service --replace-fail "/usr/bin/sleep" "${coreutils}/bin/sleep"
    substituteInPlace $out/lib/systemd/system/onedrive@.service --replace-fail "/usr/bin/sleep" "${coreutils}/bin/sleep"
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
