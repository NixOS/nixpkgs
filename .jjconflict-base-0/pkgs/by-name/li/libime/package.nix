{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  boost,
  python3,
  fcitx5,
  zstd,
}:

let
  tableVer = "20240108";
  table = fetchurl {
    url = "https://download.fcitx-im.org/data/table-${tableVer}.tar.zst";
    hash = "sha256-Pp2HsEo5PxMXI0csjqqGDdI8N4o9T2qQBVE7KpWzYUs=";
  };
  arpaVer = "20241001";
  arpa = fetchurl {
    url = "https://download.fcitx-im.org/data/lm_sc.arpa-${arpaVer}.tar.zst";
    hash = "sha256-VJNOc5Zus46k/o6unGHf5IavN9octTFqBrGcfSieMGM=";
  };
  dictVer = "20241001";
  dict = fetchurl {
    url = "https://download.fcitx-im.org/data/dict-${dictVer}.tar.zst";
    hash = "sha256-0zE7iKaGIKI7yNX5VkzxtniEjcevVBxPXwIZjlo2hr8=";
  };
in
stdenv.mkDerivation rec {
  pname = "libime";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "libime";
    rev = version;
    hash = "sha256-Ky4ERYQRUiPn+EYrgfmfHxdVp31a1oD4nevDniPOT20=";
    fetchSubmodules = true;
  };

  prePatch = ''
    ln -s ${table} data/$(stripHash ${table})
    ln -s ${arpa} data/$(stripHash ${arpa})
    ln -s ${dict} data/$(stripHash ${dict})
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    python3
  ];

  buildInputs = [
    zstd
    boost
    fcitx5
  ];

  meta = with lib; {
    description = "Library to support generic input method implementation";
    homepage = "https://github.com/fcitx/libime";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
