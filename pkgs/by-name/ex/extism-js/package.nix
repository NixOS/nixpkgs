# Building this from source requires cross-compiling Rust to wasm32-wasip1.
# An attempt to do so was made in https://github.com/NixOS/nixpkgs/pull/463349.
# FIXME revisit once https://github.com/NixOS/nixpkgs/pull/463720 is merged

{
  autoPatchelfHook,
  fetchurl,
  lib,
  libgcc,
  stdenvNoCC,
  versionCheckHook,
}:

let
  version = "1.5.1";
  tag = "v${version}";
  system = lib.replaceStrings [ "darwin" ] [ "macos" ] stdenvNoCC.hostPlatform.system;
  hashes = {
    aarch64-darwin = "sha256-BHld8Dwwd6fexc05oHOIawa5PtGZAI61wQGWE8T+iMs=";
    aarch64-linux = "sha256-KM3/y31OdLmEAcc48TSLmXei2GD6FhOHYlD7W/ErP+I=";
    x86_64-darwin = "sha256-cE0JJK92pTJyGnHEZ7wA6+dpMvVOTMzFM2Mkwfy5kbQ=";
    x86_64-linux = "sha256-9qSjqPFmUaUnpGQ/ldIpyFSgTWbUYozcckpYxpm5PJU=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "extism-js";
  inherit version;

  src = fetchurl {
    url = "https://github.com/extism/js-pdk/releases/download/${tag}/extism-js-${system}-${tag}.gz";
    hash = hashes.${stdenvNoCC.hostPlatform.system};
  };

  unpackPhase = ''
    runHook preUnpack

    gunzip -cf "$src" > extism-js

    runHook postUnpack
  '';

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    libgcc
  ];

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin extism-js

    runHook postInstall
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    changelog = "https://github.com/extism/js-pdk/releases/tag/${tag}";
    description = "Write Extism plugins in JavaScript & TypeScript";
    homepage = "https://github.com/extism/js-pdk";
    license = lib.licenses.bsd3;
    mainProgram = "extism-js";
    maintainers = [ lib.maintainers.dotlambda ];
    platforms = lib.attrNames hashes;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
