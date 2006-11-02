source $stdenv/setup
source $substitute

args=

# Select all environment variables that start with a lowercase character.
for envVar in $(env | sed "s/^[^a-z].*//" | sed "s/^\([^=]*\)=.*/\1/"); do
    echo "$envVar -> ${!envVar}"
    args="$args --subst-var $envVar"
done

substitute $src $out $args

if test -n "$isExecutable"; then
    chmod +x $out
fi
