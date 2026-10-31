{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  cmake,
  pkg-config,
  kdePackages,
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
  arpaVer = "20260629";
  arpa = fetchurl {
    url = "https://download.fcitx-im.org/data/lm_sc.arpa-${arpaVer}.tar.zst";
    hash = "sha256-BoCDM7kXPlN0zyy1r8EtCPViW/mrtTZInKw3b8BfLn8=";
  };
  dictVer = "20260703";
  dict = fetchurl {
    url = "https://download.fcitx-im.org/data/dict-${dictVer}.tar.zst";
    hash = "sha256-xobKtt+JZMSNWW9X0gW6wx/HKHCwaoMBfkRQPfjAlpc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libime";
  version = "1.1.16";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "libime";
    tag = finalAttrs.version;
    hash = "sha256-SDp7j37ZtIQ+YqOh+JKGaPgnrz0sVIom3lJx0Jmbk38=";
    fetchSubmodules = true;
  };

  prePatch = ''
    ln -s ${table} data/$(stripHash ${table})
    ln -s ${arpa} data/$(stripHash ${arpa})
    ln -s ${dict} data/$(stripHash ${dict})
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    python3
  ];

  buildInputs = [
    zstd
    boost
    fcitx5
  ];

  meta = {
    description = "Library to support generic input method implementation";
    homepage = "https://github.com/fcitx/libime";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ poscat ];
    platforms = lib.platforms.linux;
  };
})
