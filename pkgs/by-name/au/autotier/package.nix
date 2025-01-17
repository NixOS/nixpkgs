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
  tbb_2021_11,
  liburing,
  installShellFiles,
}:
let
  version = "1.2.0";
in
stdenv.mkDerivation {
  name = "autotier";
  version = version;
  src = fetchFromGitHub {
    owner = "45Drives";
    repo = "autotier";
    rev = "v${version}";
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
  ];

  buildInputs = [
    rocksdb
    boost
    fuse3
    lib45d
    tbb_2021_11
    liburing
  ];

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    # binaries
    mkdir -p $out/bin
    cp dist/from_source/* $out/bin/

    # docs
    installManPage doc/man/autotier.8

    # Completions
    installShellCompletion --bash doc/completion/autotier.bash-completion
    installShellCompletion --bash doc/completion/autotierfs.bash-completion

    # Scripts
    install -Dm755 -t $out/bin/ script/autotier-init-dirs

    # Default config
    install -Dm755 -t $out/etc/autotier.conf doc/autotier.conf.template

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/45Drives/autotier";
    description = "A passthrough FUSE filesystem that intelligently moves files between storage tiers based on frequency of use, file age, and tier fullness.";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ philipwilk ];
    platforms = lib.platforms.linux; # uses io_uring so only available on linux not unix
  };
}
