{
  lib,
  stdenv,
  fetchFromGitHub,
  librime,
}:

stdenv.mkDerivation {
  pname = "rime-data";
  version = "0-unstable-2026-10-08";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "plum";
    rev = "b1be1969f914cc005add4090631b855db00c2591";
    sha256 = "sha256-o16OYMjYrLhoo0H9hw7s/VnXAs+vS0OIY29T1v96WDE=";
  };

  buildInputs = [ librime ];

  buildFlags = [ "all" ];
  makeFlags = [ "PREFIX=$(out)" ];

  preBuild = import ./fetchSchema.nix fetchFromGitHub;

  postPatch = ''
    # Disable git operations.
    sed -i /fetch_or_update_package$/d scripts/install-packages.sh
  '';

  meta = {
    description = "Schema data of Rime Input Method Engine";
    longDescription = ''
      Rime-data provides schema data for Rime Input Method Engine.
    '';
    homepage = "https://rime.im";
    license = with lib.licenses; [
      # rime-array
      # rime-combo-pinyin
      # rime-double-pinyin
      # rime-middle-chinese
      # rime-scj
      # rime-soutzoe
      # rime-stenotype
      # rime-wugniu
      gpl3Only

      # plum
      # rime-bopomofo
      # rime-cangjie
      # rime-emoji
      # rime-essay
      # rime-ipa
      # rime-jyutping
      # rime-luna-pinyin
      # rime-prelude
      # rime-quick
      # rime-stroke
      # rime-terra-pinyin
      # rime-wubi
      lgpl3Only

      # rime-pinyin-simp
      asl20

      # rime-cantonese
      cc-by-40
    ];
    maintainers = with lib.maintainers; [ pmy ];
  };
}
