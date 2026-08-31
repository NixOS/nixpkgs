{
  lib,
  stdenv,
  fetchurl,
}:

let
  platforms = {
    x86_64-linux = {
      filename = "qodana_linux_x86_64";
      hash = "sha256-5dMwLlwA1r3A9TD05IUoBbiKvGXzSUO8QqYb0z4L1cU=";
    };
    x86_64-darwin = {
      filename = "qodana_darwin_x86_64";
      hash = "sha256-j8vrpoAm8zoNJlsGS7tgfobId11Omq3gyr8bJiCtYBU=";
    };
    aarch64-linux = {
      filename = "qodana_linux_arm64";
      hash = "sha256-8bi6G+XcRTuofeT3XF+G5ZRFuxPeQH+AnORHWgSxpw0=";
    };
    aarch64-darwin = {
      filename = "qodana_darwin_arm64";
      hash = "sha256-uAFn9aT/LAVGcbmFqx3MTVnRSchv0RVZNVQ61NBceqc=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  version = "2024.1.8";
  pname = "qodana-cli";

  # Qodana cannot currently be built from source because it uses a private git submodule
  src =
    let
      p = platforms.${stdenv.hostPlatform.system};
    in
    fetchurl {
      url = "https://github.com/JetBrains/qodana-cli/releases/download/v${finalAttrs.version}/${p.filename}";
      hash = p.hash;
    };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -DTm755 $src $out/bin/qodana-cli

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/JetBrains/qodana-cli";
    description = "JetBrains Qodana’s official command line tool";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.asl20;
    platforms = builtins.attrNames platforms;
    maintainers = [ lib.maintainers.ners ];
  };
})
