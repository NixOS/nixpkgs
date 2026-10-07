nixFile=pkgs/by-name/in/intel-llvm/package.nix

nix-update intel-llvm.unwrapped --override-filename "$nixFile" \
  --use-github-releases --version-regex '^v(\d+\.\d+\.\d+)$'

# `commitDate` has to move with the version, or the bump silently
# keeps claiming the feature set of the previous release. It is not
# derivable from the tarball, as fetchFromGitHub drops `.git`.
version=$(sed -n 's/^ *version = "\(.*\)";$/\1/p' "$nixFile")
[ -n "$version" ] || { echo "failed to read back version" >&2; exit 1; }

commitDate=$(
  curl -sSf "https://api.github.com/repos/intel/llvm/commits/v$version" \
    | jq -r .commit.committer.date | cut -dT -f1 | tr -d -
)

sed -i "s/commitDate = \"[0-9]*\"/commitDate = \"$commitDate\"/" "$nixFile"
grep -q "commitDate = \"$commitDate\";" "$nixFile" ||
  { echo "failed to update commitDate to $commitDate" >&2; exit 1; }

vcRev=$(
  curl -sSf "https://raw.githubusercontent.com/intel/llvm/v$version/llvm/lib/SYCLLowerIR/CMakeLists.txt" \
    | sed -n 's/^ *set(LLVMGenXIntrinsics_GIT_TAG \([^ )]*\)).*/\1/p'
)
[ -n "$vcRev" ] || { echo "failed to extract LLVMGenXIntrinsics_GIT_TAG" >&2; exit 1; }

if ! grep -q "rev = \"$vcRev\";" "$nixFile"; then
  vcHash=$(nix-prefetch-github intel vc-intrinsics --rev "$vcRev" | jq -r .hash)

  vcOldRev=$(nix eval --raw -f . intel-llvm.vc-intrinsics-src.rev)
  vcOldHash=$(nix eval --raw -f . intel-llvm.vc-intrinsics-src.hash)

  sed -i \
    -e "s|rev = \"$vcOldRev\";|rev = \"$vcRev\";|" \
    -e "s|hash = \"$vcOldHash\";|hash = \"$vcHash\";|" \
    "$nixFile"
  if ! grep -q "rev = \"$vcRev\";" "$nixFile" || ! grep -q "hash = \"$vcHash\";" "$nixFile"; then
    echo "failed to update vc-intrinsics-src" >&2
    exit 1
  fi
fi
