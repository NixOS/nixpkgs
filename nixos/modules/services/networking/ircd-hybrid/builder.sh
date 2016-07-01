source $stdenv/setup

doSub() {
    local src=$1
    local dst=$2
    mkdir -p $(dirname $dst)
    substituteAll $src $dst
}

subDir=/
for i in $scripts; do
    if test "$(echo $i | cut -c1-2)" = "=>"; then
        subDir=$(echo $i | cut -c3-)
    else
        dst=$out/$subDir/$(baseHash $i | sed 's/\.in//')
        doSub $i $dst
        chmod +x $dst # !!!
    fi
done

subDir=/
for i in $substFiles; do
    if test "$(echo $i | cut -c1-2)" = "=>"; then
        subDir=$(echo $i | cut -c3-)
    else
        dst=$out/$subDir/$(baseHash $i | sed 's/\.in//')
        doSub $i $dst
    fi
done

mkdir -p $out/bin
