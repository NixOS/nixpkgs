{
  lib,
  llvmPackages,
  stdenv,
  callPackage,
  dart,
  fetchFromGitHub,
  fetchgit,
  flutter341,
  jsoncpp,
  libsecret,
  runCommand,
  writeText,
  autoPatchelfHook,
  fprintd,
}:

let
  version = "6.4.3";
  flutter = flutter341;
  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes = lib.importJSON ./git-hashes.json;

  upstreamSrc = fetchFromGitHub {
    owner = "cake-tech";
    repo = "cake_wallet";
    tag = "v${version}";
    hash = "sha256-/SNSyZiTodjiHZ5BTVJuM4duHF0DIwFUBMfXnEOAioI=";
  };

  dnssecProof = callPackage ./dnssec-proof.nix {
    src = fetchgit {
      inherit (pubspecLock.packages.dnssec_proof.description) url;
      rev = pubspecLock.packages.dnssec_proof.description.resolved-ref;
      hash = gitHashes.dnssec_proof;
    };
  };
  mweb = callPackage ./mweb.nix { inherit upstreamSrc version; };
  moneroC = callPackage ./monero-c.nix {
    src = fetchgit {
      inherit (pubspecLock.packages.monero.description) url;
      rev = pubspecLock.packages.monero.description.resolved-ref;
      hash = gitHashes.monero;
      fetchSubmodules = true;
    };
  };
  rlz = callPackage ./rlz.nix {
    inherit (pubspecLock.packages.rlz) version;
    src = fetchgit {
      inherit (pubspecLock.packages.rlz.description) url;
      rev = pubspecLock.packages.rlz.description.resolved-ref;
      hash = gitHashes.rlz;
    };
  };
  spScanner = callPackage ./sp-scanner.nix { };
  warpApiFfi = callPackage ./warp-api-ffi.nix { };

  torchDart = fetchFromGitHub {
    owner = "MrCyjaneK";
    repo = "torch_dart";
    rev = "a8601eaef00ac4a9465a0979b7d7a16df90bc364";
    hash = "sha256-EmTa+7SI4clsnvaKyFdnT0vbtWr48+D5D3THLadFuxo=";
  };

  reownFlutter = fetchFromGitHub {
    owner = "cake-tech";
    repo = "reown_flutter";
    rev = "8a6d79ef7a268c493eeba45feef9991eea119bbd";
    hash = "sha256-n3mUCSGACFMhV2y7Qffr/hRFgadRWJNgGJOuJCt3+hE=";
  };

  bitboxFlutter = fetchFromGitHub {
    owner = "konstantinullrich";
    repo = "bitbox_flutter";
    rev = "5a6e6dd388ef64003f86094af80d5453518b601d";
    hash = "sha256-wLHFhSHdJFvTIIi517gbGVusBcynbgwc02SkI78bdUA=";
  };

  # These path dependencies are downloaded by upstream's CI before
  # running Pub. Zcash's Dart bindings are supplied by the same source tree as
  # the native Warp API library.
  src = runCommand "cake-wallet-${version}-source" { nativeBuildInputs = [ dart ]; } ''
    cp -R ${upstreamSrc} "$out"
    chmod -R u+w "$out"
    cp -R ${torchDart} "$out/scripts/torch_dart"
    cp -R ${reownFlutter} "$out/scripts/reown_flutter"
    cp -R ${bitboxFlutter} "$out/scripts/bitbox_flutter"
    cp -R ${warpApiFfi.src} "$out/scripts/zcash_lib"
    install -Dm644 ${mweb}/include/libmweb.h \
      "$out/cw_mweb/android/src/main/jniLibs/arm64-v8a/libmweb.h"
    chmod -R u+w "$out/scripts/zcash_lib"
    mkdir -p "$out/scripts/zcash_lib/assets"
    touch "$out/scripts/zcash_lib/assets/sapling-spend.params"
    touch "$out/scripts/zcash_lib/assets/sapling-output.params"

    cd "$out"
    substituteInPlace pubspec_base.yaml \
      --replace-fail \
        $'dev_dependencies:\n  flutter_test:' \
        $'dev_dependencies:\n  flutter_lints: ^2.0.0\n  flutter_test:'
    dart tool/generate_pubspec.dart
    dart tool/configure.dart \
      --monero \
      --bitcoin \
      --ethereum \
      --polygon \
      --nano \
      --bitcoinCash \
      --solana \
      --tron \
      --wownero \
      --zcash \
      --dogecoin \
      --base \
      --arbitrum \
      --bsc
    substituteInPlace pubspec.yaml \
      --replace-fail "version: 0.0.0" "version: ${version}"
    substituteInPlace lib/src/screens/pin_code/pin_code_widget.dart \
      --replace-fail \
        'WidgetsBinding.instance.addPostFrameCallback((_) {' \
        'WidgetsBinding.instance.addPostFrameCallback((duration) {' \
      --replace-fail '_afterLayout(_);' '_afterLayout(duration);'
    substituteInPlace lib/view_model/exchange/exchange_trade_view_model.dart \
      --replace-fail 'catch (_) {' 'catch (error) {' \
      --replace-fail \
        'Error calculating receive amount fiat formatted: $_' \
        'Error calculating receive amount fiat formatted: $error' \
      --replace-fail \
        'Error calculating send amount fiat formatted: $_' \
        'Error calculating send amount fiat formatted: $error'
    substituteInPlace lib/view_model/exchange/exchange_view_model.dart \
      --replace-fail 'catch (_) {' 'catch (error) {' \
      --replace-fail 'amount fiat formatted: $_' 'amount fiat formatted: $error'
  '';
in
flutter.buildFlutterApplication {
  pname = "cake-wallet";
  inherit version src;
  strictDeps = true;
  __structuredAttrs = true;

  inherit pubspecLock gitHashes;

  customSourceBuilders =
    let
      useNixBuiltCargokitLibrary =
        pname: library: cargokitDir:
        { version, src, ... }:
        stdenv.mkDerivation {
          inherit
            pname
            version
            src
            ;
          inherit (src) passthru;

          postPatch =
            let
              fakeCargokitCmake = writeText "FakeCargokit.cmake" ''
                function(apply_cargokit target manifest_dir lib_name any_symbol_name)
                  set("''${target}_cargokit_lib" ${library} PARENT_SCOPE)
                endfunction()
              '';
            in
            ''
              cp ${fakeCargokitCmake} ${cargokitDir}/cmake/cargokit.cmake
            '';

          installPhase = ''
            runHook preInstall
            cp -R . "$out"
            runHook postInstall
          '';
        };
    in
    {
      dnssec_proof =
        useNixBuiltCargokitLibrary "dnssec_proof" "${dnssecProof}/lib/libdnssec_proof.so"
          "cargokit";
      rlz = useNixBuiltCargokitLibrary "rlz" "${rlz}/lib/librlz.so" "rust_builder/cargokit";
      sp_scanner = useNixBuiltCargokitLibrary "sp_scanner" "${spScanner}/lib/libsp_scanner.so" "cargokit";
    };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    jsoncpp
    libsecret
    stdenv.cc.cc.lib
  ];

  # Rive bundles older HarfBuzz and SheenBidi sources which trigger warnings
  # added by the current Clang while enabling -Werror.
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/cake-wallet/lib \
    --prefix PATH : ${lib.makeBinPath [ fprintd ]}
  '';

  # buildDartApplication does not currently materialize passAsFile values when
  # structured attributes are enabled.
  preConfigure = ''
    export pubspecLockFilePath="$NIX_BUILD_TOP/pubspec.lock.json"
    printf %s "$pubspecLockFile" > "$pubspecLockFilePath"
  '';

  postPatch = ''
    substituteInPlace linux/CMakeLists.txt \
      --replace-fail \
        '"''${CMAKE_CURRENT_SOURCE_DIR}/../scripts/zcash_lib/target/release/libwarp_api_ffi.so"' \
        '"${warpApiFfi}/lib/libwarp_api_ffi.so"' \
      --replace-fail \
        '"''${MONERO_C_RELEASE_DIR}/libmonero_wallet2_api_c.so"' \
        '"${moneroC}/lib/libmonero_wallet2_api_c.so"' \
      --replace-fail \
        '"''${MONERO_C_RELEASE_DIR}/libwownero_wallet2_api_c.so"' \
        '"${moneroC}/lib/libwownero_wallet2_api_c.so"'
  '';

  preBuild = ''
    # Keep these public constants stable for reproducible builds and compatibility
    # with wallets created by previous package versions.
    dart --packages=.dart_tool/package_config.json \
      tool/generate_new_secrets.dart \
      salt=00000000000000000000000000000000 \
      keychainSalt=000000000000000000000000 \
      key=00000000000000000000000000000000 \
      walletSalt=00000000 \
      shortKey=000000000000000000000000 \
      backupSalt=0000000000000000 \
      backupKeychainSalt=000000000000000000000000 \
      walletGroupSalt=00000000000000000000000000000000

    printf 'const breezApiKey = "";\n' > cw_bitcoin/lib/.secrets.g.dart

    root="$PWD"
    localPackages=(
      cw_core
      cw_evm
      cw_mweb
      cw_monero
      cw_bitcoin
      cw_nano
      cw_bitcoin_cash
      cw_solana
      cw_tron
      cw_wownero
      cw_zcash
      cw_dogecoin
    )

    for package in "''${localPackages[@]}"; do
      mkdir -p "$package/.dart_tool"
      cp --remove-destination pubspec.lock "$package/pubspec.lock"
      jq --arg root "$root" --arg source "file://${src}//" '
        .packages |= map(
          select(.name != "cake_wallet") |
          if (.rootUri | startswith($source)) then
            .rootUri = ("file://" + $root + "/" + (.rootUri | ltrimstr($source)))
          elif (.rootUri | startswith("../")) then
            .rootUri = ("file://" + $root + "/" + (.rootUri | ltrimstr("../")))
          else
            .
          end
        )
      ' .dart_tool/package_config.json > "$package/.dart_tool/package_config.json"

      if [[ "$package" == cw_mweb ]]; then
        printf '\nllvm-path:\n  - ${lib.getLib llvmPackages.libclang}\n' \
          >> "$package/ffigen_config.yaml"
        (
          cd "$package"
          packageRun ffigen --config ffigen_config.yaml
        )
      else
        (
          cd "$package"
          packageRun build_runner build --delete-conflicting-outputs
        )
      fi
    done

    jq --arg root "$root" --arg source "file://${src}//" '
      .packages |= map(
        if (.rootUri | startswith($source)) then
          .rootUri = ("file://" + $root + "/" + (.rootUri | ltrimstr($source)))
        elif (.rootUri | startswith("../")) then
          .rootUri = ("file://" + $root + "/" + (.rootUri | ltrimstr("../")))
        else
          .
        end
      )
    ' .dart_tool/package_config.json > package_config.json
    mv package_config.json .dart_tool/package_config.json

    packageRun build_runner build --delete-conflicting-outputs
    dart --packages=.dart_tool/package_config.json tool/generate_localization.dart

    while read -r dir; do
      relativeDir="''${dir#res/pictures}"
      outputDir="assets/new-ui$relativeDir"
      mkdir -p "$outputDir"
      packageRun vector_graphics_compiler \
        --input-dir "$dir" \
        --out-dir "$outputDir" \
        --libpathops ${flutter.cacheDir.flutterPlatform.universal}/bin/cache/artifacts/engine/linux-x64/libpath_ops.so \
        --libtessellator ${flutter.cacheDir.flutterPlatform.universal}/bin/cache/artifacts/engine/linux-x64/libtessellator.so
    done < <(find res/pictures -type d)
  '';

  postInstall = ''
    install -Dm755 ${mweb}/lib/libmweb.so "$out/app/cake-wallet/lib/libmweb.so"

    install -Dm644 linux/com.cakewallet.CakeWallet.desktop \
      "$out/share/applications/com.cakewallet.CakeWallet.desktop"

    for size in 120 180 1024; do
      install -Dm644 "assets/images/cakewallet_icon_$size.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/com.cakewallet.CakeWallet.png"
    done
  '';

  passthru = {
    inherit
      upstreamSrc
      torchDart
      reownFlutter
      bitboxFlutter
      dnssecProof
      mweb
      moneroC
      rlz
      ;
    flutterSdk = flutter;
    zcashLib = warpApiFfi.src;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Non-custodial multi-currency cryptocurrency wallet";
    homepage = "https://cakewallet.com/";
    changelog = "https://github.com/cake-tech/cake_wallet/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "cake_wallet";
    platforms = [ "x86_64-linux" ];
  };
}
