{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  fetchFromGitHub,
  fetchSwiftPMDeps,
  makeWrapper,
  unzip,
  swift,
  swiftpm,
  sqlite,
  versionCheckHook,
  writeShellScript,
  nix-update,
  jq,
  common-updater-scripts,
}:

let
  pname = "codexbar";
  version = "0.76.0";

  passthru.updateScript = writeShellScript "update-codexbar" ''
    set -euo pipefail

    ${lib.getExe nix-update} codexbar --system x86_64-linux --custom-dep swiftpmVendor
    version=$(nix eval --raw --file . codexbar.version)
    url=$(nix eval --raw --file . codexbar.src.url --system aarch64-darwin)
    hash=$(nix store prefetch-file --json "$url" | ${lib.getExe jq} --raw-output .hash)
    ${lib.getExe' common-updater-scripts "update-source-version"} codexbar "$version" "$hash" --system=aarch64-darwin --ignore-same-version --ignore-same-hash
  '';

  meta = {
    description = "Show usage stats for AI coding-provider limits";
    homepage = "https://codex.bar/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Br1ght0ne
      kinnrai
    ];
    platforms = lib.platforms.darwin ++ [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "codexbar";
  };
in
if stdenvNoCC.hostPlatform.isDarwin then
  stdenvNoCC.mkDerivation (finalAttrs: {
    inherit pname version passthru;
    __structuredAttrs = true;
    strictDeps = true;

    src = fetchurl {
      url = "https://github.com/steipete/CodexBar/releases/download/v${finalAttrs.version}/CodexBar-macos-universal-${finalAttrs.version}.zip";
      hash = "sha256-abKC78odg8FNhK1nzsW55PmM/qHORuAO+QJ5LsWCp6Q=";
    };

    sourceRoot = ".";

    nativeBuildInputs = [
      makeWrapper
      unzip
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r CodexBar.app $out/Applications
      makeWrapper $out/Applications/CodexBar.app/Contents/MacOS/CodexBar $out/bin/codexbar

      runHook postInstall
    '';

    meta = meta // {
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  })
else
  stdenv.mkDerivation (finalAttrs: {
    inherit pname version meta;
    __structuredAttrs = true;
    strictDeps = true;

    src = fetchFromGitHub {
      owner = "steipete";
      repo = "CodexBar";
      tag = "v${finalAttrs.version}";
      hash = "sha256-8zRvGTtxMxzz3Pkj4FWtJWAIAPV3auCKxaWC9ITqwhI=";
    };

    swiftpmDeps = fetchSwiftPMDeps {
      inherit (finalAttrs) pname version src;
      hash = "sha256-VqleMLzhrt/1zNcx29YpRx1746zJJScW6Wnx3B+xors=";
    };

    postPatch = ''
      # Sparkle is a prebuilt macOS-only binary target
      sed -i '/github\.com\/sparkle-project\/Sparkle"/d' Package.swift

      # SwiftPM copies SweetCookieKit's resources with their read-only permissions
      rm Packages
      mkdir Packages
      ln -s $swiftpmDeps/Packages/* Packages/
      rm Packages/SweetCookieKit
      cp -r --no-preserve=mode $swiftpmDeps/Packages/SweetCookieKit Packages/
    '';

    nativeBuildInputs = [
      swift
      swiftpm
    ];

    buildInputs = [ sqlite ];

    swiftpmFlags = [
      "--product"
      "CodexBarCLI"
    ];

    installPhase = ''
      runHook preInstall

      binPath="$(swiftpmBinPath)"
      install -Dm755 "$binPath/CodexBarCLI" $out/libexec/codexbar/codexbar
      cp -r "$binPath/CodexBar_CodexBarCore.bundle" $out/libexec/codexbar/
      echo ${finalAttrs.version} > $out/libexec/codexbar/VERSION
      mkdir -p $out/bin
      ln -s ../libexec/codexbar/codexbar $out/bin/codexbar

      runHook postInstall
    '';

    nativeInstallCheckInputs = [ versionCheckHook ];
    doInstallCheck = true;

    passthru = passthru // {
      swiftpmVendor = finalAttrs.swiftpmDeps.vendorStaging;
    };
  })
