{
  lib,
  stdenv,
  fetchFromGitHub,
  bundlerEnv,
  bundlerUpdateScript,
  ruby_3_4,
  makeWrapper,
  nodejs,
  thruster,
  sqlite,
  vips,
  openssl,
  libyaml,
  pkg-config,
  perl,
}:

let
  runtimeLibPath = lib.makeLibraryPath [ vips ];

  addDeps = nativeBuildInputs: buildInputs: attrs: {
    nativeBuildInputs = (attrs.nativeBuildInputs or [ ]) ++ nativeBuildInputs;
    buildInputs = (attrs.buildInputs or [ ]) ++ buildInputs;
  };
in
stdenv.mkDerivation (rec {
  pname = "fizzy";
  version = "unstable-2026-03-03";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "basecamp";
    repo = "fizzy";
    rev = "6e3ee266ec28053bdc8f49aa5f72f16e638dd8a4";
    hash = "sha256-fWskgVBUgPIpeLI82UZrBmmYAKe0cCaMajQ+lZC//N0=";
  };

  rubyEnv = bundlerEnv {
    name = "fizzy-gems-${version}";
    ruby = ruby_3_4;
    gemdir = src;
    gemfile = ./gemdir/Gemfile;
    lockfile = ./gemdir/Gemfile.lock;
    gemset = ./gemdir/gemset.nix;
    ignoreCollisions = true;
    gemConfig = {
      mittens = addDeps [ perl ] [ ];
      psych = addDeps [ pkg-config ] [ libyaml ];
      openssl =
        attrs:
        (addDeps [ pkg-config ] [ ] attrs)
        // {
          buildFlags = (attrs.buildFlags or [ ]) ++ [
            "--with-openssl-include=${openssl.dev}/include"
            "--with-openssl-lib=${openssl.out}/lib"
          ];
        };
      trilogy = addDeps [ pkg-config ] [ openssl ];
      sqlite3 =
        attrs:
        (addDeps [ pkg-config ] [ sqlite ] attrs)
        // {
          buildFlags = [
            "--with-sqlite3-include=${sqlite.dev}/include"
            "--with-sqlite3-lib=${sqlite.out}/lib"
          ];
        };
    };
  };

  gemHome = "${rubyEnv}/${ruby_3_4.gemPath}";
  runtimeBinPath = lib.makeBinPath [
    rubyEnv.wrappedRuby
    nodejs
    thruster
  ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    rubyEnv
    sqlite
    vips
    openssl
  ];

  commonWrapArgs = [
    "--prefix"
    "PATH"
    ":"
    runtimeBinPath
    "--chdir"
    (placeholder "out")
    "--set-default"
    "RAILS_ENV"
    "production"
    "--set"
    "BUNDLE_GEMFILE"
    "${rubyEnv.confFiles}/Gemfile"
    "--set"
    "BUNDLE_FORCE_RUBY_PLATFORM"
    "true"
    "--set"
    "GEM_HOME"
    gemHome
    "--set"
    "GEM_PATH"
    gemHome
    "--set"
    "LD_LIBRARY_PATH"
    runtimeLibPath
    "--set"
    "DYLD_FALLBACK_LIBRARY_PATH"
    runtimeLibPath
  ];

  env = {
    RAILS_ENV = "production";
    BUNDLE_WITHOUT = "development:test";
    BUNDLE_GEMFILE = "${rubyEnv.confFiles}/Gemfile";
    BUNDLE_FROZEN = "1";
    BUNDLE_FORCE_RUBY_PLATFORM = "true";
    GEM_HOME = gemHome;
    GEM_PATH = gemHome;
    LD_LIBRARY_PATH = runtimeLibPath;
    DYLD_FALLBACK_LIBRARY_PATH = runtimeLibPath;
  };

  buildPhase = ''
    runHook preBuild

    patchShebangs bin/

    bundle exec bootsnap precompile --gemfile app/ lib/
    SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r --no-preserve=ownership . "$out"/

    runHook postInstall
  '';

  postInstall = ''
    makeWrapper $out/bin/thrust $out/bin/fizzy-server \
      ${lib.escapeShellArgs commonWrapArgs} \
      --add-flags "$out/bin/rails server"

    for exe in rails rake thrust; do
      wrapProgram $out/bin/$exe ${lib.escapeShellArgs commonWrapArgs}
    done
  '';

  passthru = {
    updateScript = bundlerUpdateScript "fizzy";
  };

  meta = {
    description = "Kanban tracking tool for issues and ideas";
    longDescription = ''
      Fizzy is an open-source Kanban tracking tool for issues and ideas,
      originally built and used by 37signals. It supports multi-tenancy,
      SQLite and MySQL, web push notifications (VAPID), and deployment
      via Kamal or Docker.
    '';
    homepage = "https://fizzy.do/";
    changelog = "https://github.com/basecamp/fizzy/releases";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "fizzy-server";
    platforms = lib.platforms.unix; # Builds on Darwin but explicitly only enabled for Linux internally
  };
})
