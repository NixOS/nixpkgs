{
  fetchurl,
  lib,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maqao";
  version = "2026.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl (
    {
      x86_64-linux = {
        url = "https://www.maqao.org/maqao_archive/maqao.x86_64.${finalAttrs.version}.tar.xz";
        hash = "sha256-tESTLDiGF+zFEd2LNkxXHroCFcBe6w4Su7xY7gWcAFY=";
      };
      aarch64-linux = {
        url = "https://www.maqao.org/maqao_archive/maqao.aarch64.${finalAttrs.version}.tar.xz";
        hash = "sha256-BeoS6YutLwkyztOAj7BSEePneq/X23o0BQOLX8ylMPI=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "maqao: unsupported system ${stdenv.hostPlatform.system}")
  );

  # Prebuilt, statically linked binaries, no patchelf needed.
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/maqao $out/bin/maqao
    install -Dm644 man/man1/*.1 -t $out/share/man/man1
    install -Dm644 LICENSE -t $out/share/licenses/maqao
    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Performance analysis and optimization framework operating at binary level";
    homepage = "https://www.maqao.org";
    downloadPage = "https://www.maqao.org/download.html";
    license = lib.licenses.lgpl3Plus;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "maqao";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = [ lib.maintainers.arthurk ];
  };
})
