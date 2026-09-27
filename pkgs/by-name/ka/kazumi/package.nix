{
  lib,
  stdenv,
  flutter,
  fetchurl,
  fetchFromGitHub,
  autoPatchelfHook,
  alsa-lib,
  cacert,
  glib-networking,
  gst_all_1,
  libayatana-appindicator,
  mpv-unwrapped,
  webkitgtk_4_1,
  _experimental-update-script-combinators,
  nix-update-script,
  runCommand,
  writeShellApplication,
  yq-go,
  dart,
  jq,
  curl,
  coreutils,
  gnutar,
}:

let
  version = "2.3.6";

  src = fetchFromGitHub {
    owner = "Predidit";
    repo = "Kazumi";
    tag = version;
    hash = "sha256-63GJ5ORld5OLlBYBULfsD1SuMBiuEv6h4Z2yGafHJn8=";
  };

  echDeps = lib.importJSON ./ech-http-deps.json;

  echTarget =
    {
      x86_64-linux = "linux-x64";
      aarch64-linux = "linux-arm64";
    }
    .${stdenv.hostPlatform.system}
      or (throw "kazumi: unsupported platform ${stdenv.hostPlatform.system}");

  echDepsSdk = fetchurl {
    inherit (echDeps.${echTarget}) url hash;
  };
in

flutter.buildFlutterApplication {
  pname = "kazumi";
  inherit version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes = lib.importJSON ./git-hashes.json;

  nativeBuildInputs = [
    autoPatchelfHook
    yq-go
  ];

  buildInputs = [
    alsa-lib
    cacert
    glib-networking
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    libayatana-appindicator
    mpv-unwrapped
    webkitgtk_4_1
  ];

  postPatch = ''
    # Disable the Bangumi proxy by default.
    substituteInPlace lib/services/storage/settings_keys.dart \
      --replace-fail $'_SettingBoxKey.enableBangumiProxy,\n    true,' $'_SettingBoxKey.enableBangumiProxy,\n    false,'
  '';

  preBuild = ''
    # Configure media_kit to link system libraries, and configure ech_http to use the local cache.
    yq --inplace \
      '.hooks.user_defines = {
        "media_kit": { "source": "system" },
        "ech_http": { "binary_cache": ".dart_tool/ech_http_cache" }
      }' \
      pubspec.yaml

    # Retrieve the cache filename hash from ech_http's package metadata to stay in sync with upstream.
    echRoot="$(jq --raw-output '.packages[] | select(.name == "ech_http") | .rootUri | sub("file://"; "")' .dart_tool/package_config.json)"
    echDigest="$(jq --raw-output '.targets["${echTarget}"].sha256' "$echRoot/lib/src/build_support/dependencies.json")"
    mkdir -p .dart_tool/ech_http_cache
    cp "${echDepsSdk}" ".dart_tool/ech_http_cache/${echTarget}-''${echDigest}.zip"
  '';

  postInstall = ''
    install -Dm 0644 assets/linux/io.github.Predidit.Kazumi.desktop -t $out/share/applications/
    install -Dm 0644 assets/images/logo/logo_linux.png $out/share/icons/hicolor/512x512/apps/io.github.Predidit.Kazumi.png
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Ensure HTTPS certificate bundle is available to fix TLS verification
      --set SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt"
      --prefix LD_LIBRARY_PATH : "${mpv-unwrapped}/lib:$out/app/$pname/lib"
    )
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

    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "kazumi.pubspecSource" ./pubspec.lock.json)
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
      {
        command = [
          (lib.getExe (writeShellApplication {
            name = "kazumi-update-ech-http-deps";
            runtimeInputs = [
              curl
              jq
              coreutils
              gnutar
            ];
            text = ''
              version="$(jq --raw-output '.packages.ech_http.version' ${lib.escapeShellArg (toString ./pubspec.lock.json)})"

              tmp="$(mktemp -d)"
              trap 'rm -rf "$tmp"' EXIT

              curl --fail --silent --show-error --location \
                "https://pub.dev/api/archives/ech_http-$version.tar.gz" |
                tar --extract --gzip --directory "$tmp"

              manifest="$tmp/lib/src/build_support/dependencies.json"

              manifestUrl() {
                jq --raw-output --arg target "$1" '.targets[$target].url' "$manifest"
              }

              manifestSha() {
                jq --raw-output --arg target "$1" '.targets[$target].sha256' "$manifest"
              }

              toSri() {
                printf '%s' "$1" | basenc --base16 --decode | base64 --wrap=0
              }

              jq --null-input \
                --arg arm64Url "$(manifestUrl linux-arm64)" \
                --arg arm64Hash "sha256-$(toSri "$(manifestSha linux-arm64)")" \
                --arg x64Url "$(manifestUrl linux-x64)" \
                --arg x64Hash "sha256-$(toSri "$(manifestSha linux-x64)")" \
                '{
                  "linux-arm64": { url: $arm64Url, hash: $arm64Hash },
                  "linux-x64": { url: $x64Url, hash: $x64Hash },
                }' \
                > ${lib.escapeShellArg (toString ./ech-http-deps.json)}
            '';
          }))
        ];
        supportedFeatures = [ ];
      }
    ];
  };

  meta = {
    description = "Watch Animes online with danmaku support";
    homepage = "https://github.com/Predidit/Kazumi";
    mainProgram = "kazumi";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ lonerOrz ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
