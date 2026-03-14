{
  lib,
  stdenv,
  fetchzip,
}:
let
  arch_os =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "linux-x64"
    else if stdenv.hostPlatform.system == "aarch64-linux" then
      "linux-aarch64"
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      "mac-x64"
    else if stdenv.hostPlatform.system == "aarch64-darwin" then
      "mac-aarch64"
    else
      null;
  zip_sha =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "sha256-EweSqy30NJuxvlJup78O+e+JOkzvUdb6DshqAy1j9jE="
    else if stdenv.hostPlatform.system == "aarch64-linux" then
      "sha256-MhHEYHBctaDH9JVkN/guDCG1if9Bip1aP3n+JkvHCvA="
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      "sha256-zMuUcahT1IiCT1NTrMCIzUNM0U6U3zaBkJtbGrzF7I8="
    else if stdenv.hostPlatform.system == "aarch64-darwin" then
      "sha256-zwlzVt3KYN0OXKr6sI9XSijXSbTImomSTGRGa+3zCK8="
    else
      null;
  java_bin_path =
    if
      stdenv.hostPlatform.system == "x86_64-linux" || stdenv.hostPlatform.system == "aarch64-linux"
    then
      "jre/bin/java"
    else if
      stdenv.hostPlatform.system == "x86_64-darwin" || stdenv.hostPlatform.system == "aarch64-darwin"
    then
      "jre/Contents/Home/bin/java"
    else
      null;

in
stdenv.mkDerivation rec {
  pname = "kotlin-lsp";
  version = "261.13587.0";
  src = fetchzip {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${version}/kotlin-lsp-${version}-${arch_os}.zip";
    hash = zip_sha;

    stripRoot = false;
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/native
    mkdir -p $out/bin
    mkdir -p $out/jre
    cp -r lib/* $out/lib
    cp -r native/* $out/native
    cp -r jre/* $out/jre
    cp kotlin-lsp.sh $out
    ln -s $out/kotlin-lsp.sh $out/bin/kotlin-lsp
    chmod +x $out/kotlin-lsp.sh
    chmod +x $out/bin/kotlin-lsp
    chmod +x $out/${java_bin_path}
  '';

  meta = {
    description = "Language Server for Kotlin";
    longDescription = ''
      Official Kotlin implementation of Language Server Protocol for the Kotlin language.
    '';
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    changelog = "https://github.com/Kotlin/kotlin-lsp/releases/tag/kotlin-lsp%2Fv${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "kotlin-lsp";
  };
}
