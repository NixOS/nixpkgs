{
  stdenv,
  fetchFromGitHub,
  lib,
  python3,
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
stdenv.mkDerivation rec {
  pname = "bfscripts";
  version = "unstable-2023-05-15";

  src = fetchFromGitHub {
    owner = "Mellanox";
    repo = pname;
    rev = "1da79f3ece7cdf99b2571c00e8b14d2e112504a4";
    hash = "sha256-pTubrnZKEFmtAj/omycFYeYwrCog39zBDEszoCrsQNQ=";
  };

  buildInputs = [
    python3
  ];

  installPhase = ''
    ${lib.concatStringsSep "\n" (map (b: "install -D ${b} $out/bin/${b}") binaries)}
  '';

  meta = with lib; {
    description = "Collection of scripts used for BlueField SoC system management";
    homepage = "https://github.com/Mellanox/bfscripts";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nikstur ];
  };
}
