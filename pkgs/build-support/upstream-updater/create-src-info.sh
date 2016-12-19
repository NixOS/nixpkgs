#! /bin/sh

[ -z "$1" ] && {
  echo "Use $0 expression-basename download-page package-base-name"
  echo "Like:"
  echo "$0 default http://example.com/downloads hello"
  exit 1;
} >&2

own_dir="$(cd "$(dirname "$0")"; sh -c pwd)"

cp "$own_dir/../builder-defs/template-auto-callable.nix" "$1.nix" 
sed -e "s@src-for-default.nix@src-for-$1.nix@g" -i "$1.nix"
echo '{}' > "src-for-$1.nix"
cat << EOF > src-info-for-$1.nix
{
  downloadPage = "$2";
  baseName = "$3";
}
EOF
