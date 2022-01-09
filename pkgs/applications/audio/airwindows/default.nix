{ stdenv, lib, fetchFromGitHub, requireFile, fetchzip, cmake }:

stdenv.mkDerivation rec {
  pname = "airwindows";
  version = "unstable-2022-01-29";

  src = fetchFromGitHub {
    owner = "airwindows";
    repo = "airwindows";
    rev = "f1e7313c284110347f2907ebe47ad1c03a9b2e9e";
    sha256 = "sha256-3P65nnSTceSoFHSFkYLr5yXCyRGgV5Zg6L0R4wP7XTw=";
  };

  # equal to vst-sdk in ../oxefmsynth/default.nix
  vst-sdk = stdenv.mkDerivation rec {
    name = "vstsdk3610_11_06_2018_build_37";
    src = fetchzip {
      url = "https://web.archive.org/web/20181016150224if_/https://download.steinberg.net/sdk_downloads/${name}.zip";
      sha256 = "0da16iwac590wphz2sm5afrfj42jrsnkr1bxcy93lj7a369ildkj";
    };
    installPhase = ''
      cp -r . $out
    '';
  };

  airwindows-ports = stdenv.mkDerivation rec {
    name = "airwindows-ports";
    src = fetchFromGitHub {
      owner = "ech2";
      repo = "airwindows-ports";
      rev = "0.4.0";
      sha256 = "1ya4qbc63sb52nzisdapsydrnnpqnjsl5kgxibbr3dxf32474g89";
    };
    installPhase = "cp -r . $out";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    cd plugins/LinuxVST
    mkdir -p include/vstsdk
    cp -r ${airwindows-ports}/include/vstsdk/CMakeLists.txt include/vstsdk/
    cp -r ${vst-sdk}/VST2_SDK/pluginterfaces include/vstsdk/pluginterfaces
    cp -r ${vst-sdk}/VST2_SDK/public.sdk/source/vst2.x/* include/vstsdk/
    chmod -R 755 include/vstsdk/pluginterfaces
  '';

  installPhase = ''
    runHook preInstall
    for so_file in *.so; do
      install -vDm 644 $so_file -t "$out/lib/lxvst"
    done;
    runHook postInstall
  '';

  meta = with lib; {
    description = "Handsewn bespoke linuxvst plugins";
    homepage = "https://www.airwindows.com/airwindows-linux/";
    # airwindows is mit, but the vst sdk is unfree
    licenses = with licenses; [ mit unfree ];
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
