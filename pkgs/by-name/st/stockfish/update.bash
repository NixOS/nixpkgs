new_src="$(nix-build --attr "pkgs.$PNAME.src" --no-out-link)"
new_nnue_big_file="$(grep --perl-regexp --only-matching 'EvalFileDefaultNameBig "\Knn-(\w+).nnue' "$new_src/src/evaluate.h")"
new_nnue_small_file="$(grep --perl-regexp --only-matching 'EvalFileDefaultNameSmall "\Knn-(\w+).nnue' "$new_src/src/evaluate.h")"
new_nnue_big_hash="$(
    nix --extra-experimental-features nix-command hash convert --hash-algo sha256 "$(
        nix-prefetch-url --type sha256 "https://tests.stockfishchess.org/api/nn/$new_nnue_big_file"
    )"
)"
new_nnue_small_hash="$(
    nix --extra-experimental-features nix-command hash convert --hash-algo sha256 "$(
        nix-prefetch-url --type sha256 "https://tests.stockfishchess.org/api/nn/$new_nnue_small_file"
    )"
)"

pkg_body="$(<"$PKG_FILE")"
pkg_body="${pkg_body//"$NNUE_BIG_FILE"/"$new_nnue_big_file"}"
pkg_body="${pkg_body//"$NNUE_BIG_HASH"/"$new_nnue_big_hash"}"
pkg_body="${pkg_body//"$NNUE_SMALL_FILE"/"$new_nnue_small_file"}"
pkg_body="${pkg_body//"$NNUE_SMALL_HASH"/"$new_nnue_small_hash"}"
echo "$pkg_body" >"$PKG_FILE"
