source $stdenv/setup

export HOME=$(mktemp -d)

# Call once first outside of subshell for better error reporting
go mod download "$goPackagePath@$version"

dir=$(go mod download --json "$goPackagePath@$version" | jq -r .Dir)

chmod -R +w $dir
find $dir -iname ".ds_store" | xargs -r rm -rf

cp -r $dir $out
