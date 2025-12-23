{
  fetchFromGitHub,
  git,
  lib,
  python3,
  rpm,
  stdenv,
}:

let
  # Most of the binaries are not really useful because they have hardcoded
  # paths that only make sense when you're running the stock BlueField OS on
  # your BlueField. These might be patched in the future with resholve
  # (https://github.com/abathur/resholve). If there is one that makes sense
  # without resholving it, it can simply be uncommented and will be included in
  # the output.
  binaries = [
    # "bfacpievt"
    # "bfbootmgr"
    # "bfcfg"
    # "bfcpu-freq"
    # "bfdracut"
    # "bffamily"
    # "bfgrubcheck"
    # "bfhcafw"
    # "bfinst"
    # "bfpxe"
    # "bfrec"
    "bfrshlog"
    # "bfsbdump"
    # "bfsbkeys"
    # "bfsbverify"
    # "bfver"
    # "bfvcheck"
    "mlx-mkbfb"
    "bfup"
  ];
in
stdenv.mkDerivation {
  pname = "bfscripts";
  version = "3.9.7-1-unstable-2025-11-18";

  src = fetchFromGitHub {
    owner = "Mellanox";
    repo = "bfscripts";
    rev = "1bc9bdfc3196da25b5565f473e95d27ddecfbc9d";
    hash = "sha256-db2jnPtYbSCwa8pwuu6z4Cho/TgVZvgPJaPnqcsmdSQ=";
  };

  buildInputs = [
    python3
  ];

  nativeBuildInputs = [
    git
    rpm
  ];

  installPhase = ''
    ${lib.concatStringsSep "\n" (map (b: "install -D ${b} $out/bin/${b}") binaries)}
  '';

  meta = {
    description = "Collection of scripts used for BlueField SoC system management";
    homepage = "https://github.com/Mellanox/bfscripts";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      nikstur
      thillux
    ];
  };
}
