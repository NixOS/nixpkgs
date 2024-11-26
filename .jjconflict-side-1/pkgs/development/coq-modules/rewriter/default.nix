{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
}:

mkCoqDerivation {
  pname = "rewriter";
  owner = "mit-plv";
  inherit version;
  defaultVersion =
    let
      inherit (lib.versions) range;
    in
    lib.switch coq.coq-version [
      {
        case = range "8.17" "8.19";
        out = "0.0.11";
      }
    ] null;
  release = {
    "0.0.11".sha256 = "sha256-aYoO08nwItlOoE5BnKRGib2Zk4Fz4Ni/L4QaqkObPow=";
  };
  releaseRev = v: "v${v}";

  mlPlugin = true;

  meta = {
    description = "Reflective PHOAS rewriting/pattern-matching-compilation framework for simply-typed equalities and let-lifting, experimental and tailored for use in Fiat Cryptography";
    license = lib.licenses.mit;
  };
}
