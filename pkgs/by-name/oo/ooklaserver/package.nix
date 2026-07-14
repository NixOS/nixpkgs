{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:
let
  filenameMapping = {
    "x86_64-linux" = "OoklaServer-linux-x86_64-static-musl.zip";
    "aarch64-linux" = "OoklaServer-linux-aarch64-static-musl.zip";
    # Mach-O universal binary with 2 architectures: [x86_64:Mach-O 64-bit executable x86_64] [arm64]
    "x86_64-darwin" = "OoklaServer-macosx.zip";
    "aarch64-darwin" = "OoklaServer-macosx.zip";
    "x86_64-windows" = "OoklaServer-windows64.zip";
    "i686-windows" = "OoklaServer-windows32.zip";
    # OoklaServer-linux64-deb9.zip
    # OoklaServer-freebsd12_64.zip
    # OoklaServer-freebsd13_64.zip
  };
in
stdenv.mkDerivation {
  version = "2.11.1.2";
  pname = "ooklaserver";

  src = fetchurl {
    url = "https://web.archive.org/web/20240703022648/https://install.speedtest.net/ooklaserver/stable/OoklaServer.tgz";
    hash = "sha256-tctLtTGmrVHs+4pI1PRHrqY+a4ISs6TKvLRKlFdWw88=";
  };
  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall
    unzip ${filenameMapping.${stdenv.system}}
    install -Dm555 OoklaServer${stdenv.hostPlatform.extensions.executable} "$out/bin/OoklaServer"
    install -Dm444 OoklaServer.properties.default "$out/etc/OoklaServer.properties.default"
    runHook postInstall
  '';

  meta = {
    description = "Ookla TCP based server daemon that provides standalone testing";
    homepage = "https://www.speedtest.net";
    changelog = "https://support.ookla.com/hc/en-us/articles/234578608-Speedtest-Server-Release-Notes";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ neverbehave ];
    platforms = builtins.attrNames filenameMapping;
    mainProgram = "OoklaServer";
  };
}
