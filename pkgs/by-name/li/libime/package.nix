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
  arpaVer = "20250113";
  arpa = fetchurl {
    url = "https://download.fcitx-im.org/data/lm_sc.arpa-${arpaVer}.tar.zst";
    hash = "sha256-7oPs8g1S6LzNukz2zVcYPVPCV3E6Xrd+46Y9UPw3lt0=";
  };
  dictVer = "20250327";
  dict = fetchurl {
    url = "https://download.fcitx-im.org/data/dict-${dictVer}.tar.zst";
    hash = "sha256-fKa+R1TA1MJ7p3AsDc5lFlm9LKH6pcvyhI2BoAU8jBM=";
  };
in
stdenv.mkDerivation rec {
  pname = "libime";
  version = "1.1.12";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "libime";
    tag = version;
    hash = "sha256-LqbwXpmqUCbaKHaaE9pOrHb1Qdp20/S3QEf9F4/3oiE=";
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
