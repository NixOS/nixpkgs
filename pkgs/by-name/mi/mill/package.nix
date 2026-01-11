{
  autoPatchelfHook,
  fetchurl,
  jre,
  lib,
  makeWrapper,
  sourcesJSON ? ./sources.json,
  stdenvNoCC,
  zlib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mill";
  version = "1.0.6";

  src =
    let
      source = (lib.importJSON sourcesJSON)."${stdenvNoCC.hostPlatform.system}";
    in
    fetchurl {
      url = "https://repo1.maven.org/maven2/com/lihaoyi/mill-dist-${source.artifact-suffix}/${finalAttrs.version}/mill-dist-${source.artifact-suffix}-${finalAttrs.version}.exe";
      inherit (source) hash;
    };

  buildInputs = [ zlib ];
  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optional stdenvNoCC.hostPlatform.isLinux autoPatchelfHook;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  # this is mostly downloading a pre-built artifact
  preferLocal = true;

  installPhase = ''
    runHook preInstall

    install -Dm 555 $src $out/bin/.mill-wrapped
    # can't use wrapProgram because it sets --argv0
    makeWrapper $out/bin/.mill-wrapped $out/bin/mill \
      --prefix PATH : "${jre}/bin" \
      --set-default JAVA_HOME "${jre}"

    runHook postInstall
  '';

  meta = {
    homepage = "https://com-lihaoyi.github.io/mill/";
    license = lib.licenses.mit;
    description = "Build tool for Scala, Java and more";
    mainProgram = "mill";
    longDescription = ''
      Mill is a build tool borrowing ideas from modern tools like Bazel, to let you build
      your projects in a way that's simple, fast, and predictable. Mill has built in
      support for the Scala programming language, and can serve as a replacement for
      SBT, but can also be extended to support any other language or platform via
      modules (written in Java or Scala) or through an external subprocesses.
    '';
    maintainers = with lib.maintainers; [
      zenithal
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
