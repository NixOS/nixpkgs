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
  version = "unstable-2025-06-27";

  src = fetchFromGitHub {
    owner = "Mellanox";
    repo = "bfscripts";
    rev = "ed8ede79fa002a2d83719a1bef6fbe0f7dcf37a4";
    hash = "sha256-x+hpH6D5HTl39zD0vYj6wRFw881M4AcfM+ePcgXMst8=";
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

  meta = with lib; {
    description = "Collection of scripts used for BlueField SoC system management";
    homepage = "https://github.com/Mellanox/bfscripts";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      nikstur
      thillux
    ];
  };
}
