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
  version = "1.6.0";
  tag = "v${version}";
  system = lib.replaceStrings [ "darwin" ] [ "macos" ] stdenvNoCC.hostPlatform.system;
  hashes = {
    aarch64-darwin = "sha256-VI4lvaOXGgfDLXiiSRNc+Mt7Pu3hAeh44G5T4BrC4M4=";
    aarch64-linux = "sha256-FaGGJQ5o1r/07IOf/yddRakOODppIJ3MEjnrnjrubhs=";
    x86_64-darwin = "sha256-2FqHXCoHHwwp/lcnZMUsOkmfFXq3+e+siTmkNkOQ4ps=";
    x86_64-linux = "sha256-Te0nHM9GUDHM0Nw156FA4TTX8wchZxzEqOH/gF1KrWg=";
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

  # https://github.com/extism/js-pdk/pull/154
  preInstallCheck = ''
    version=1.5.1
  '';

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
