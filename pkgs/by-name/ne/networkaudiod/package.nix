{
  stdenv,
  autoPatchelfHook,
  dpkg,
  fetchurl,
  lib,
  alsa-lib,
}:
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";
in
stdenv.mkDerivation rec {
  pname = "networkaudiod";
  version = "4.1.1-46";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://www.signalyst.eu/bins/naa/linux/buster/${pname}_${version}_amd64.deb";
        sha256 = "sha256-un5VcCnvCCS/KWtW991Rt9vz3flYilERmRNooEsKCkA=";
      };
      aarch64-linux = fetchurl {
        url = "https://www.signalyst.eu/bins/naa/linux/buster/${pname}_${version}_arm64.deb";
        sha256 = "sha256-fjSCWX9VYhVJ43N2kSqd5gfTtDJ1UiH4j5PJ9I5Skag=";
      };
    }
    .${system} or throwSystem;

  unpackPhase = ''
    dpkg -x $src .
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    alsa-lib
    (lib.getLib stdenv.cc.cc)
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # main executable
    mkdir -p $out/bin
    cp ./usr/sbin/networkaudiod $out/bin

    # systemd service file
    mkdir -p $out/lib/systemd/system
    cp ./lib/systemd/system/networkaudiod.service $out/lib/systemd/system

    # documentation
    mkdir -p $out/share/doc/networkaudiod
    cp -r ./usr/share/doc/networkaudiod $out/share/doc/

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/lib/systemd/system/networkaudiod.service \
      --replace /usr/sbin/networkaudiod $out/bin/networkaudiod
  '';

  meta = with lib; {
    homepage = "https://www.signalyst.com/index.html";
    description = "Network Audio Adapter daemon";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ lovesegfault ];
    platforms = platforms.linux;
    mainProgram = "networkaudiod";
  };
}
