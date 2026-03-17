{
  lib,
  stdenv,
  fetchFromGitHub,
  bundlerEnv,
  bundler,
  bundix,
  coreutils,
  git,
  nix,
  nixfmt,
  writeShellScript,
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
stdenv.mkDerivation rec {
  pname = "fizzy";
  version = "0-unstable-2026-10-15";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "basecamp";
    repo = "fizzy";
    rev = "2568389d94412f46cee5587a61d9a83d05f183ff";
    hash = "sha256-ji5QUiXY99+Ylkmx5S1GFQHKSOuK9RB0KONzCcE8Sa0=";
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
      # mittens builds Snowball source that invokes a Perl script using an
      # /usr/bin/env shebang; patch it to the Nix-provided Perl in the sandbox.
      mittens =
        attrs:
        (addDeps [ perl ] [ ] attrs)
        // {
          dontBuild = false;
          postPatch = ''
            patchShebangs vendor/snowball/libstemmer
          '';
        };
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
    rubyEnv.wrappedRuby
    nodejs
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
    "--set"
    "FIZZY_PACKAGE_ROOT"
    (placeholder "out")
    "--set-default"
    "RAILS_ENV"
    "production"
    "--set-default"
    "BINDING"
    "::1"
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

  fizzyRuntime = writeShellScript "fizzy-runtime" ''
    set -euo pipefail
    runtimeRoot="''${XDG_STATE_HOME:-''${HOME:?HOME must be set}/.local/state}/fizzy"
    mkdir -p "$runtimeRoot"

    for entry in "$FIZZY_PACKAGE_ROOT"/* "$FIZZY_PACKAGE_ROOT"/.[!.]* "$FIZZY_PACKAGE_ROOT"/..?*; do
      [ -e "$entry" ] || [ -L "$entry" ] || continue
      name="''${entry##*/}"
      case "$name" in
        bin|storage|tmp) continue ;;
      esac
      ln -sfn "$entry" "$runtimeRoot/$name"
    done

    mkdir -p "$runtimeRoot/bin" "$runtimeRoot/storage" "$runtimeRoot/tmp"
    for executable in rails rake; do
      temporary="$runtimeRoot/bin/.$executable.$$"
      cp "$FIZZY_PACKAGE_ROOT/libexec/$executable" "$temporary"
      chmod +x "$temporary"
      mv -f "$temporary" "$runtimeRoot/bin/$executable"
    done
    cd "$runtimeRoot"
  '';

  fizzyServer = writeShellScript "fizzy-server" ''
    source ${fizzyRuntime}

    exec ${thruster}/bin/thrust "$runtimeRoot/bin/rails" server "$@"
  '';

  fizzyCli = writeShellScript "fizzy-cli" ''
    source ${fizzyRuntime}

    case "''${FIZZY_CLI:?}" in
      rails|rake) exec "$runtimeRoot/bin/$FIZZY_CLI" "$@" ;;
      thrust) exec ${thruster}/bin/thrust "$runtimeRoot/bin/rails" server "$@" ;;
      *) echo "unsupported Fizzy command: $FIZZY_CLI" >&2; exit 64 ;;
    esac
  '';

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
    mkdir -p $out/libexec
    for exe in rails rake; do
      cp "$out/bin/$exe" "$out/libexec/$exe"
    done
    rm $out/bin/thrust

    makeWrapper ${fizzyServer} $out/bin/fizzy-server \
      ${lib.escapeShellArgs commonWrapArgs}

    for exe in rails rake thrust; do
      makeWrapper ${fizzyCli} $out/bin/$exe \
        --set FIZZY_CLI "$exe" \
        ${lib.escapeShellArgs commonWrapArgs}
    done
  '';

  passthru = {
    updateScript = [
      (writeShellScript "fizzy-update-script" ''
        set -o errexit
        set -o nounset
        set -o pipefail

        export PATH=${
          lib.makeBinPath [
            bundler
            bundix
            coreutils
            git
            nix
            nixfmt
          ]
        }
        root=$(git rev-parse --show-toplevel)
        gemdir="$root/pkgs/by-name/fi/fizzy/gemdir"
        cd "$gemdir"
        export BUNDLE_GEMFILE="$gemdir/Gemfile"
        export BUNDLE_FORCE_RUBY_PLATFORM=1
        tmpdir=$(mktemp -d "''${TMPDIR:-/tmp}/fizzy-bundler-update.XXXXXX")
        trap 'rm -rf "$tmpdir"' EXIT
        export TMPDIR="$tmpdir"

        if [ "''${2:-}" = "--resolve-changed" ]; then
          # Resolve a newly added Gemfile dependency without upgrading unrelated gems.
          rm -f gemset.nix
          bundler lock
        else
          rm -f Gemfile.lock gemset.nix
          bundler lock --update
        fi
        bundix
        nixfmt gemset.nix
      '')
      "fizzy"
    ];
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
    platforms = lib.platforms.unix;
  };
}
