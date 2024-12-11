{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "libviperfx";
  version = "unstable-2018-01-15";

  src = fetchFromGitHub {
    owner = "vipersaudio";
    repo = "viperfx_core_binary";
    rev = "6f7d0da725affe854f083baf5d90c70e172e4488";
    sha256 = "sha256-hfX46Kk91eQgiO3uhew91I6eEHxazhdGwSkhfNZ+HvQ=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D libviperfx_x64_linux.so $out/lib/libviperfx.so
    install -D README.md $out/share/licenses/libviperfx/LICENSE
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/vipersaudio/viperfx_core_binary";
    description = "ViPER FX core";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ rewine ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
