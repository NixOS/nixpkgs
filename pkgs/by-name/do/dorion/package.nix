{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, fetchurl
, rustPlatform
, autoPatchelfHook
, wrapGAppsHook
, esbuild
, glib-networking
, gst_all_1
, libappindicator
, libayatana-appindicator
, nodejs
, openssl
, pkg-config
, yq-go
, pnpm-lock-export
, prefetch-yarn-deps
, webkitgtk
, yarn
}:

let

  pname = "dorion";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "SpikeHD";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-s1EQ2DcvxkPh0w3PwfNqzYDlW1vuWXsZ+WgYKO8mDMM=";

    nativeBuildInputs = [ pnpm-lock-export ];
    postFetch = ''
      (cd $out && pnpm-lock-export --schema yarn.lock@v1)
    '';
  };

  shelter = fetchurl {
    url = "https://raw.githubusercontent.com/uwu/shelter-builds/6fe00ccba268a7ec5f6c35111da3f9a070a448b7/shelter.js";
    hash = "sha256-t/s/8dddJ58la+jUHTyjUHF9xMAQe8UPixNwPvyUnRs=";
    meta = {
      homepage = "https://github.com/uwu/shelter";
      sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
      license = lib.licenses.cc0;
    };
  };

  frontend = stdenv.mkDerivation {
    pname = "dorion-ui";
    inherit version src;

    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/yarn.lock";
      hash = "sha256-tEIaEQqnnrbJMMPICVAdU0EQ6AxhLJ3xhGczUQoG1W0=";
    };

    nativeBuildInputs = [
      nodejs
      prefetch-yarn-deps
      yarn
    ];

    env.ESBUILD_BINARY_PATH = lib.getExe (esbuild.overrideAttrs (final: _: {
      version = "0.18.20";
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        rev = "v${final.version}";
        hash = "sha256-mED3h+mY+4H465m02ewFK/BgA1i/PQ+ksUNxBlgpUoI=";
      };
      vendorHash = "sha256-mED3h+mY+4H465m02ewFK/BgA1i/PQ+ksUNxBlgpUoI=";
    }));

    postPatch = ''
      substituteInPlace package.json --replace 'pnpm build:' 'yarn run build:'
    '';

    configurePhase = ''
      runHook preConfigure

      export HOME=$(mktemp -d)
      yarn config --offline set yarn-offline-mirror $offlineCache
      fixup-yarn-lock yarn.lock
      yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
      patchShebangs node_modules/

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      cp ${shelter} src-tauri/injection/shelter.js
      yarn --offline build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r src-tauri/{injection,html} $out

      runHook postInstall
    '';
  };

in

rustPlatform.buildRustPackage {
  inherit version src pname;

  sourceRoot = "${src.name}/src-tauri";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rsrpc-0.10.0" = "sha256-+rc99XVDop3Czc9a1mlxPQRKzWOZYQNdsrMrULcpAIM=";
      "tauri-plugin-window-state-0.1.0" = "sha256-eFtCQRzqPR0U+qHcdJDf5GYbCsx9LESwNTd8Z4m3Kng=";
      "window_titles-0.1.0" = "sha256-lk2T+6curAwqOUuQ8RtYCjX2ygGBgzt4ILBAMV+ql0w=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    yq-go
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    openssl
    webkitgtk
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    glib-networking
  ];

  runtimeDependencies = [
    libappindicator
    libayatana-appindicator
  ];

  env.TAURI_RESOURCE_DIR = "${placeholder "out"}/lib";

  postPatch = ''
    # disable pre-build script, change distribution dir from an URL to src, and disable auto-updater
    yq -iPo json '. + {
      "build": .build + {
        "beforeBuildCommand": "",
        "distDir": "src"
      },
      "tauri": .tauri + {
        "bundle": .tauri.bundle + {
          "resources": [.tauri.bundle.resources[] | select(. | contains("updater") | not)]
        }
      }
    }' tauri.conf.json

    (cd $cargoDepsCopy/tauri-utils-* && patch -p3 <${./tauri-env-resource-dir.patch})
  '';

  preConfigure = ''
    cp -r ${frontend}/* ./
  '';

  postInstall = ''
    mkdir -p $out/lib/dorion
    cp -r {injection,html} $out/lib/dorion
  '';

  passthru = {
    inherit frontend;
  };

  meta = {
    homepage = "https://github.com/SpikeHD/Dorion";
    description = "Tiny alternative Discord client";
    license = lib.licenses.gpl3Only;
    mainProgram = "dorion";
    maintainers = with lib.maintainers; [ nyanbinary ];
    platforms = lib.platforms.linux;
  };
}
