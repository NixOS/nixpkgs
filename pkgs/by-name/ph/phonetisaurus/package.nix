{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  openfst,
  pkg-config,
  python3,
}:

let
  openfst_1_7_9 = openfst.overrideAttrs (old: rec {
    version = "1.7.9";
    src = fetchurl {
      url = "http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-${version}.tar.gz";
      hash = "sha256-kxmusx0eKVCuJUSYhOJVzCvJ36+Yf2AVkHY+YaEPvd4=";
    };

    postPatch = (old.postPatch or "") + ''
      # Fix the 's_' typo that breaks modern GCC
      substituteInPlace src/include/fst/bi-table.h \
        --replace-fail "selector_(table.s_)" "selector_(table.selector_)"

      # Fix invalid unique_ptr assignments for modern C++ standards
      substituteInPlace src/include/fst/fst.h \
        --replace-fail "isymbols_ = impl.isymbols_ ? impl.isymbols_->Copy() : nullptr;" "isymbols_.reset(impl.isymbols_ ? impl.isymbols_->Copy() : nullptr);" \
        --replace-fail "osymbols_ = impl.osymbols_ ? impl.osymbols_->Copy() : nullptr;" "osymbols_.reset(impl.osymbols_ ? impl.osymbols_->Copy() : nullptr);"
    '';
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "phonetisaurus";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "AdolfVonKleist";
    repo = "phonetisaurus";
    tag = finalAttrs.version;
    hash = "sha256-Lt7xKLrpcLw8ouLfCJZdWDb0XfrmW+LM+fe8st3B8ow=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    python3
    openfst_1_7_9
  ];

  meta = {
    description = "Framework for Grapheme-to-phoneme models for speech recognition using the OpenFst framework";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mic92 ];
    platforms = lib.platforms.unix;
  };
})
