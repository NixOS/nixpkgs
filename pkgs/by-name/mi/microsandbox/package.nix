{
  autoPatchelfHook,
  fetchurl,
  lib,
  libcap_ng,
  stdenv,
  versionCheckHook,
}:

let
  sources = {
    "x86_64-linux" = {
      url = "https://github.com/superradcompany/microsandbox/releases/download/v0.4.6/microsandbox-linux-x86_64.tar.gz";
      hash = "sha256-gCb8yykJBNJ8Y0v19hhdOPu+UVyUEoHkZ2fQ93Jvbac=";
    };
    "aarch64-linux" = {
      url = "https://github.com/superradcompany/microsandbox/releases/download/v0.4.6/microsandbox-linux-aarch64.tar.gz";
      hash = "sha256-5LFHqCfSlbGJVPMJQkjaNLSdf+8neguahElpUkHNRtM=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "microsandbox: unsupported platform ${stdenv.hostPlatform.system}");

  libkrunfwVersion = "5.2.1";
  libkrunfwAbi = "5";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "microsandbox";
  version = "0.4.6";

  src = fetchurl {
    inherit (source) url hash;
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    libcap_ng
    stdenv.cc.cc.lib
  ];

  sourceRoot = ".";

  appendRunpaths = [ "${placeholder "out"}/lib" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 msb -t $out/bin
    ln -s msb $out/bin/microsandbox

    install -Dm644 libkrunfw.so.${libkrunfwVersion} -t $out/lib
    ln -s libkrunfw.so.${libkrunfwVersion} $out/lib/libkrunfw.so.${libkrunfwAbi}
    ln -s libkrunfw.so.${libkrunfwAbi} $out/lib/libkrunfw.so

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/msb";
  versionCheckProgramArg = "--version";

  meta = {
    description = "Self-hostable sandbox for running untrusted code in microVMs";
    longDescription = ''
      Microsandbox launches OCI-compatible images inside microVMs backed by
      libkrun, providing kernel-level isolation while keeping startup times
      comparable to containers. It exposes a JSON-RPC API and a Model
      Context Protocol server so AI agents and other automation can spin
      up sandboxed environments on demand.
    '';
    homepage = "https://microsandbox.dev/";
    changelog = "https://github.com/superradcompany/microsandbox/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "msb";
    maintainers = with lib.maintainers; [ conao3 ];
    platforms = lib.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
