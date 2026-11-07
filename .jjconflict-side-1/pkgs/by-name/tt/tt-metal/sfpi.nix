{
  lib,
  stdenv,
  fetchurl,
  runCommand,
  autoPatchelfHook,
  ncurses,
  mpfr,
  libmpc,
  xz,
  zstd,
  expat,
}:
let
  version = "7.78.0";
in
runCommand "sfpi-${version}"
  {
    inherit version;

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    buildInputs = [
      ncurses
      mpfr
      libmpc
      xz
      zstd
      expat
    ];

    src =
      {
        aarch64-linux = fetchurl {
          url = "https://github.com/tenstorrent/sfpi/releases/download/${version}/sfpi_${version}_aarch64_debian.txz";
          hash = "sha256-ATcNRyNZ6c3DOb+s5k7ATpMafr6k3+DoZJYTgd0rdHI=";
        };
        x86_64-linux = fetchurl {
          url = "https://github.com/tenstorrent/sfpi/releases/download/${version}/sfpi_${version}_x86_64_debian.txz";
          hash = "sha256-RkxkdZ5EG4Qda8BiFtvUcNeg8Yjg/6msjrsuQEzyRNs=";
        };
      }
      ."${stdenv.hostPlatform.system}" or (throw "SFPI does not support ${stdenv.hostPlatform.system}");
  }
  ''
    runPhase unpackPhase
    cp -r ../"$sourceRoot" "$out"
    runPhase fixupPhase
  ''
