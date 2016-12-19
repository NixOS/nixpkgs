#! /bin/sh

[ -z "$1" ] && {
  echo "Use $0 expression-basename repo-url branch-name package-base-name"
  echo "Like:"
  echo "$0 default http://git.example.com/repo origin/master hello"
  exit 1;
} >&2

own_dir="$(cd "$(dirname "$0")"; sh -c pwd)"

cp "$own_dir/../builder-defs/template-bdp-uud.nix" "$1.nix" 
sed -e "s@src-for-default.nix@src-for-$1.nix@g; 
    s@fetchUrlFromSrcInfo@fetchGitFromSrcInfo@g" -i "$1.nix"
echo '{}' > "src-for-$1.nix"
cat << EOF > src-info-for-$1.nix
{
  repoUrl = "$2";
  rev = "$3";
  baseName = "$4";
  method = "fetchgit";
}
EOF

