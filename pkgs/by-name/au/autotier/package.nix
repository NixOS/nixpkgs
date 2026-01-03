{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  rocksdb,
  boost,
  fuse3,
  lib45d,
  onetbb,
  liburing,
  installShellFiles,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "autotier";
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "45Drives";
    repo = "autotier";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pf1baDJsyt0ScASWrrgMu8+X5eZPGJSu0/LDQNHe1Ok=";
  };

  patches = [
    # https://github.com/45Drives/autotier/pull/70
    # fix "error: 'uintmax_t' has not been declared" build failure until next release
    (fetchpatch {
      url = "https://github.com/45Drives/autotier/commit/d447929dc4262f607d87cbc8ad40a54d64f5011a.patch";
      hash = "sha256-0ab8YBgdJMxBHfOgUsgPpyUE1GyhAU3+WCYjYA2pjqo=";
    })
    # Unvendor rocksdb (nixpkgs already applies RTTI and PORTABLE flags) and use pkg-config for flags
    (fetchpatch {
      url = "https://github.com/45Drives/autotier/commit/fa282f5079ff17c144a7303d64dad0e44681b87f.patch";
      hash = "sha256-+W3RwSe8zJKgZIXOaawHuI6xRzedYIcZundPC8eHuwM=";
    })
    # Add missing list import to src/incl/config.hpp
    (fetchpatch {
      url = "https://github.com/45Drives/autotier/commit/1f97703f4dfbfe093f5c18c4ee01dcc1c8fe04f3.patch";
      hash = "sha256-3+KOh7JvbujCMbMqnZ5SGopAuOKHitKq6XV6a/jkcog=";
    })
  ];

  buildInputs = [
    rocksdb
    boost
    fuse3
    lib45d
    onetbb
    liburing
  ];

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    # binaries
    installBin dist/from_source/*

    # docs
    installManPage doc/man/autotier.8

    # Completions
    installShellCompletion --bash doc/completion/autotier.bash-completion
    installShellCompletion --bash doc/completion/autotierfs.bash-completion

    # Scripts
    installBin script/autotier-init-dirs

    # Default config
    install -Dm755 -t $out/etc/autotier.conf doc/autotier.conf.template

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/45Drives/autotier";
    description = "Passthrough FUSE filesystem that intelligently moves files between storage tiers based on frequency of use, file age, and tier fullness";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ philipwilk ];
    mainProgram = "autotier"; # cli, for file system use autotierfs
    platforms = lib.platforms.linux; # uses io_uring so only available on linux not unix
  };
})
