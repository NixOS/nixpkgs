{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mill";
  version = "1.0.0";

  src = fetchurl {
    url = "https://repo1.maven.org/maven2/com/lihaoyi/mill-dist/${finalAttrs.version}/mill-dist-${finalAttrs.version}.exe";
    hash = "sha256-pgkwME2xs4ezfWS1HGFS2uPIqqvECTOAILWmCqci2Aw=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  # this is mostly downloading a pre-built artifact
  preferLocal = true;

  installPhase = ''
    runHook preInstall
    install -Dm555 "$src" "$out/bin/mill"
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://com-lihaoyi.github.io/mill/";
    license = licenses.mit;
    description = "Build tool for Scala, Java and more";
    mainProgram = "mill";
    longDescription = ''
      Mill is a build tool borrowing ideas from modern tools like Bazel, to let you build
      your projects in a way that's simple, fast, and predictable. Mill has built in
      support for the Scala programming language, and can serve as a replacement for
      SBT, but can also be extended to support any other language or platform via
      modules (written in Java or Scala) or through an external subprocesses.
    '';
    maintainers = with maintainers; [
      scalavision
      zenithal
    ];
    platforms = lib.platforms.all;
  };
})
