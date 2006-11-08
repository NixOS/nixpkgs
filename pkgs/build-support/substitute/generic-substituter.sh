source $stdenv/setup
source $substitute

args=

target=$out
if test -n "$dir"; then
    target=$out/$dir/$name
    ensureDir $out/$dir
fi

# Select all environment variables that start with a lowercase character.
for envVar in $(env | sed "s/^[^a-z].*//" | sed "s/^\([^=]*\)=.*/\1/"); do
    echo "$envVar -> ${!envVar}"
    args="$args --subst-var $envVar"
done

substitute $src $target $args

if test -n "$isExecutable"; then
    chmod +x $target
fi
