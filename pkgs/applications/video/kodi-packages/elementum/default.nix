{ stdenv, lib, autoPatchelfHook, buildKodiAddon, addonDir, kodi, fetchurl, unzip }:
let
  python = kodi.pythonPackages.python.withPackages (p: with p; [ flake8 ]);
  os = "${stdenv.hostPlatform.system}";
  osname = {
    x86_64-linux = "linux_x64";
    x86_64-darwin = "darwin_x64";
    i686-linux = "linux_x86";
    armv7l-linux = "linux_armv7";
    aarch64-linux = "linux_arm64";
  }."${os}" or (throw "Unsupported system: ${os}");
  hash = {
    x86_64-linux = "sha256-lmaDBKX0zkMVHnKyH6RPBd1TKINoO3guD15v7OoX094=";
    x86_64-darwin = "sha256-yw3HZdWB+Cm+uUhURWnM5PVKBajAcM/9EiAX+q/aE2Q=";
    i686-linux = "sha256-D9ahCGwOmPi6hCD1k98pN1EyaiX7msgGnA8sc6VAcmo=";
    armv7l-linux = "sha256-FIM1YmVg/S65HZOD4qZp3Qv21YsmALMu5jpH3w1x8h0=";
    aarch64-linux = "sha256-heIjCEjADD9Jj2igcXWO9rizopql6b2d8ycdAo/cQ4k=";
  }."${os}" or (throw "Unsupported system: ${os}");

in
buildKodiAddon rec {
  pname = "elementum";
  namespace = "plugin.video.elementum";
  version = "0.1.83";

  src = fetchurl {
    url = "https://github.com/elgatito/plugin.video.elementum/releases/download/v${version}/plugin.video.elementum-${version}.${osname}.zip";
    sha256 = hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    python
    unzip
  ];
  buildInputs = [
    stdenv.cc.cc.lib
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out${addonDir}/${namespace}/
    cp -r ./ $out${addonDir}/${namespace}/
  '';

  meta = with lib; {
    homepage = "https://elementumorg.github.io/";
    description = "Elementum addon is an addon for Kodi, that manages your virtual library, syncs with your Trakt account .";
    license = lib.licenses.unfree;
    maintainers = with maintainers; [ almostnobody ];
  };
}
