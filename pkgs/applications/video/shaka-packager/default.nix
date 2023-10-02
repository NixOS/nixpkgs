{ lib
, stdenv
, fetchurl
, runCommand
, shaka-packager
}:

let
  sources = {
    "x86_64-linux" = {
      filename = "packager-linux-x64";
      hash = "sha256-MoMX6PEtvPmloXJwRpnC2lHlT+tozsV4dmbCqweyyI0=";
    };
    aarch64-linux = {
      filename = "packager-linux-arm64";
      hash = "sha256-6+7SfnwVRsqFwI7/1F7yqVtkJVIoOFUmhoGU3P6gdQ0=";
    };
    x86_64-darwin = {
      filename = "packager-osx-x64";
      hash = "sha256-fFBtOp/Zb37LP7TWAEB0yp0xM88cMT9QS59EwW4MrAY=";
    };
  };

  source = sources."${stdenv.hostPlatform.system}"
    or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "shaka-packager";
  version = "2.6.1";

  src = fetchurl {
    url = "https://github.com/shaka-project/shaka-packager/releases/download/v${finalAttrs.version}/${source.filename}";
    inherit (source) hash;
  };

  dontUnpack = true;
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -m755 -D $src $out/bin/packager

    runHook postInstall
  '';

  passthru.tests = {
    simple = runCommand "${finalAttrs.pname}-test" { } ''
      ${shaka-packager}/bin/packager -version | grep ${finalAttrs.version} > $out
    '';
  };

  meta = {
    description = "Media packaging framework for VOD and Live DASH and HLS applications";
    homepage = "https://shaka-project.github.io/shaka-packager/html/";
    license = lib.licenses.bsd3;
    mainProgram = "packager";
    maintainers = with lib.maintainers; [ ];
    platforms = builtins.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
