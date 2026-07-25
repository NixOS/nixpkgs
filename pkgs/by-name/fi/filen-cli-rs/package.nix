{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
}:

let
  version = "0.2.7";

  srcs = {
    "x86_64-linux" = fetchurl {
      url = "https://github.com/FilenCloudDienste/filen-cli-releases/releases/download/${version}/filen-cli-${version}-x86_64-unknown-linux-gnu";
      hash = "sha256-0Fw6SnWFy7/pNtp6R5c4mCko30lXa9I3TItgi02IkYk=";
    };
    "aarch64-linux" = fetchurl {
      url = "https://github.com/FilenCloudDienste/filen-cli-releases/releases/download/${version}/filen-cli-${version}-aarch64-unknown-linux-gnu";
      hash = "sha256-7NqNNgVuUdiJTHA0APdFuqBwdUGcPNwFgWTMJ3CIssc=";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://github.com/FilenCloudDienste/filen-cli-releases/releases/download/${version}/filen-cli-${version}-x86_64-apple-darwin";
      hash = "sha256-dD2smdtJKK+fmZ8dI7w794tqDE6jiMuRqAr/p2ThdU8=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "filen-cli-rs";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/filen
    runHook postInstall
  '';

  meta = {
    description = "CLI tool for interacting with Filen cloud storage (Rust rewrite)";
    homepage = "https://github.com/FilenCloudDienste/filen-rs";
    changelog = "https://github.com/FilenCloudDienste/filen-cli-releases/releases/tag/${version}";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.agpl3Only;
    mainProgram = "filen";
    maintainers = with lib.maintainers; [ avhb ];
    platforms = builtins.attrNames srcs;
  };
})
