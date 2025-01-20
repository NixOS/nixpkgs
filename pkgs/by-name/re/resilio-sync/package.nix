{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libxcrypt-legacy,
}:

stdenv.mkDerivation rec {
  pname = "resilio-sync";
  version = "3.0.1.1414";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://download-cdn.resilio.com/${version}/linux/x64/0/resilio-sync_x64.tar.gz";
        sha256 = "sha256-WJi9KVGqI0oAaBaldcVGuQmyXuqaCFFm9VyI6PB4CkA=";
      };

      aarch64-linux = fetchurl {
        url = "https://download-cdn.resilio.com/${version}/linux/arm64/0/resilio-sync_arm64.tar.gz";
        sha256 = "sha256-I/9eQjqYYf7upejHVOVbHEM9/iXMbIHkAb/S54pK3sQ=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  dontStrip = true; # Don't strip, otherwise patching the rpaths breaks
  sourceRoot = ".";

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.libc
    libxcrypt-legacy
  ];

  installPhase = ''
    install -D rslsync "$out/bin/rslsync"
  '';

  meta = with lib; {
    description = "Automatically sync files via secure, distributed technology";
    homepage = "https://www.resilio.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      domenkozar
      thoughtpolice
      cwoac
    ];
    mainProgram = "rslsync";
  };
}
