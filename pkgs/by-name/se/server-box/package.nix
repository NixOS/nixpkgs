{
  lib,
  flutter347,
  fetchFromGitHub,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  runCommand,
  yq-go,
  _experimental-update-script-combinators,
  nix-update-script,
  dart,
  libayatana-appindicator,
  rustPlatform,
  rustc,
  cargo,
  writeShellScriptBin,
}:

let
  version = "1.0.1719";

  src = fetchFromGitHub {
    owner = "lollipopkit";
    repo = "flutter_server_box";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-DzRDk80lwmRYDKlVuGsN7NC7wzrbrfwtGLoKJGyexPk=";
  };

  # so hook/build.dart call cargo from nixpkgs
  rustupShim = writeShellScriptBin "rustup" ''
    case "''${1-}" in
      show)
        echo "${rustc.version} (default)"
        ;;
      run)
        # `rustup run <toolchain> cargo ...` becomes `cargo ...`.
        shift 2
        exec "$@"
        ;;
      *)
        echo "rustup shim: unsupported invocation: $*" >&2
        exit 1
        ;;
    esac
  '';
in
flutter347.buildFlutterApplication {
  pname = "server-box";
  inherit version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./git-hashes.json;

  # hook/build.dart and packages/fl_pi_llm/hook/build.dart compile Rust crates with cargo
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      # both come from the same pinned revision of https://github.com/Devolutions/sspi-rs
      "sspi-0.21.3" = "sha256-mntFWhs/W55PVeNRshiHyZ6A3r77IfG4NLJm05QILVA=";
      "winscard-0.3.3" = "sha256-mntFWhs/W55PVeNRshiHyZ6A3r77IfG4NLJm05QILVA=";
    };
  };

  llmCargoDeps = rustPlatform.importCargoLock {
    lockFile = ./fl_pi_llm-Cargo.lock;
  };

  # https://github.com/rrousselGit/freezed/issues/1365
  # remove when upstream moves to freezed 4.x
  postPatch = ''
    find . -name '*.freezed.dart' -print0 | xargs -0 sed -i -E \
      '/^[[:space:]]*(const[[:space:]]+)?_[A-Za-z0-9_]+[(]/ s/\bfinal[[:space:]]+//g'

    find . -name '*.dart' -print0 | xargs -0 sed -i -E \
      -e 's/@Default\(([^()]*)\)[[:space:]]+final[[:space:]]+/@Default(\1) /g' \
      -e 's/required[[:space:]]+final[[:space:]]+/required /g'
  '';

  # neither CARGO_HOME nor .cargo/config.toml works, but ~/.cargo/config.toml works
  preBuild = ''
    mkdir -p "$HOME/.cargo" cargo-vendor-dir
    for deps in $cargoDeps $llmCargoDeps; do
      find "$deps" -mindepth 1 -maxdepth 1 \
        ! -name .cargo ! -name Cargo.lock \
        -exec cp -Lr --no-preserve=mode --reflink=auto -t cargo-vendor-dir {} +
    done
    chmod -R u+w cargo-vendor-dir

    {
      printf '[net]\noffline = true\n\n[source.crates-io]\nreplace-with = "vendored-sources"\n\n[source.vendored-sources]\ndirectory = "%s/cargo-vendor-dir"\n' "$PWD"
      for deps in $cargoDeps $llmCargoDeps; do
        sed -n '/^\[source\."/,$p' "$deps/.cargo/config.toml"
      done
    } > "$HOME/.cargo/config.toml"
    mkdir -p .cargo
    cp "$HOME/.cargo/config.toml" .cargo/config.toml
  '';

  nativeBuildInputs = [
    copyDesktopItems
    autoPatchelfHook
    cargo
    rustc
    rustupShim
  ];

  buildInputs = [
    libayatana-appindicator
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "server-box";
      exec = "ServerBox";
      icon = "server-box";
      genericName = "ServerBox";
      desktopName = "ServerBox";
      categories = [ "Utility" ];
      keywords = [
        "server"
        "ssh"
        "sftp"
        "system"
      ];
    })
  ];

  extraWrapProgramArgs = "--prefix LD_LIBRARY_PATH : $out/app/server-box/lib";

  postInstall = ''
    install -D --mode=0644 assets/app_icon.png $out/share/icons/hicolor/512x512/apps/server-box.png
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          inherit src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    llmCargoLockSource =
      runCommand "fl_pi_llm-Cargo.lock"
        {
          inherit src;
        }
        ''
          cp $src/packages/fl_pi_llm/rust/Cargo.lock "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "server-box.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "server-box.llmCargoLockSource" ./fl_pi_llm-Cargo.lock)
        // {
          supportedFeatures = [ ];
        }
      )
      {
        command = [
          dart.fetchGitHashesScript
          "--input"
          ./pubspec.lock.json
          "--output"
          ./git-hashes.json
        ];
        supportedFeatures = [ ];
      }
    ];
  };

  meta = {
    description = "Server status & toolbox";
    homepage = "https://serverbox.lpkt.cn";
    downloadPage = "https://serverbox.lpkt.cn/installation";
    changelog = "https://github.com/lollipopkit/flutter_server_box/releases/tag/${src.tag}";
    mainProgram = "ServerBox";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ulysseszhan ];
  };
}
