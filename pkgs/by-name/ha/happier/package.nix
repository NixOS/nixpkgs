{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  openssl,
}:

let
  inherit (stdenv.hostPlatform) system;

  pname = "happier";
  version = "0.2.1";

  sources = {
    aarch64-darwin = fetchurl {
      url = "https://github.com/happier-dev/happier/releases/download/cli-v${version}/happier-v${version}-darwin-arm64.tar.gz";
      hash = "sha256-Sb4uQHnEzsm04ipwP/PaVMHQpTr4prBknt4Bn1+/fsg=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/happier-dev/happier/releases/download/cli-v${version}/happier-v${version}-linux-arm64.tar.gz";
      hash = "sha256-gXLKHTEuTzuU4BlX56uuL4/IZDoVzofcrgbm/GQyKKU=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/happier-dev/happier/releases/download/cli-v${version}/happier-v${version}-darwin-x64.tar.gz";
      hash = "sha256-ymaKtVaYupPTmXHrTyuzJ34f62kkmnlXEytlJR5CfU4=";
    };
    x86_64-linux = fetchurl {
      url = "https://github.com/happier-dev/happier/releases/download/cli-v${version}/happier-v${version}-linux-x64.tar.gz";
      hash = "sha256-fH8EntUuvj6lXGEmqGqNfYnDC+Ng7o8pE2l5GdWpRnk=";
    };
  };
  platforms = builtins.attrNames sources;
in

stdenv.mkDerivation {
  inherit pname version;

  strictDeps = true;

  src =
    if builtins.elem system platforms then
      sources.${system}
    else
      throw "Source for happier is not available for ${system}";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    runHook preUnpack

    tar --warning=no-unknown-keyword -xzf $src
    sourceRoot=happier-v${version}-${stdenv.hostPlatform.parsed.kernel.name}-${
      if stdenv.hostPlatform.isAarch64 then "arm64" else "x64"
    }

    runHook postUnpack
  '';

  autoPatchelfIgnoreMissingDeps = lib.optionals stdenv.hostPlatform.isLinux [
    # Unused node-pty musl prebuild bundled in the upstream binary release.
    "libc.musl-x86_64.so.1"
  ];

  # strip removes the payload embedded in Bun standalone executables.
  dontStrip = true;

  postPatch = ''
    find . -name '._*' -delete
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/happier
    cp -r . $out/lib/happier/
    ln -s $out/lib/happier/happier $out/bin/happier

    runHook postInstall
  '';

  meta = {
    description = "Mobile and web client for Claude Code, Codex, and other coding agents";
    homepage = "https://github.com/happier-dev/happier";
    changelog = "https://github.com/happier-dev/happier/releases/tag/cli-v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ imalison ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    inherit platforms;
    mainProgram = "happier";
  };
}
