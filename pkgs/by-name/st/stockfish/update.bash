new_src="$(nix-build --attr "pkgs.$PNAME.src" --no-out-link)"
new_nnue_file="$(grep --perl-regexp --only-matching 'EvalFileDefaultName "\Knn-(\w+).nnue' "$new_src/src/evaluate.h")"
new_nnue_hash="$(
    nix --extra-experimental-features nix-command hash convert --hash-algo sha256 "$(
        nix-prefetch-url --type sha256 "https://tests.stockfishchess.org/api/nn/$new_nnue_file"
    )"
)"

pkg_body="$(<"$PKG_FILE")"
pkg_body="${pkg_body//"$NNUE_FILE"/"$new_nnue_file"}"
pkg_body="${pkg_body//"$NNUE_HASH"/"$new_nnue_hash"}"
echo "$pkg_body" >"$PKG_FILE"
