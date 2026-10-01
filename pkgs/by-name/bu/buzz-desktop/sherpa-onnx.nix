{
  fetchurl,
  linkFarm,
  stdenv,
}:

let
  version = "1.13.4";
  archives = {
    x86_64-linux = {
      file = "sherpa-onnx-v${version}-linux-x64-static-lib.tar.bz2";
      hash = "sha256-mLDjGZZCb254JE284ZVVSPLGTo8BxL51uFr3zaoujVw=";
    };
    aarch64-linux = {
      file = "sherpa-onnx-v${version}-linux-aarch64-static-lib.tar.bz2";
      hash = "sha256-I7M2Fnh8yUnVsUOOl5RVD4BeIIoBTFwiRUgyB8WLvA8=";
    };
    aarch64-darwin = {
      file = "sherpa-onnx-v${version}-osx-arm64-static-lib.tar.bz2";
      hash = "sha256-V4Adsru3hqXTQ/UVo4/yELQBhCM4vcgE+gdTEtHNJAQ=";
    };
  };

  system = stdenv.hostPlatform.system;
  archive =
    archives.${system} or (throw "sherpa-onnx ${version} has no prebuilt archive for ${system}");

  archiveFile = fetchurl {
    name = archive.file;
    url = "https://github.com/k2-fsa/sherpa-onnx/releases/download/v${version}/${archive.file}";
    inherit (archive) hash;
  };
in
linkFarm "sherpa-onnx-${version}-archives-${system}" [
  {
    name = archive.file;
    path = archiveFile;
  }
]
