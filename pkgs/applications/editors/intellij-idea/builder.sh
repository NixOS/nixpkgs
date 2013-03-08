source $stdenv/setup

export PATH=$ant/bin:$jdk/bin:$PATH

set -e 

tar -jxvf $src
cd ideaIC-111.69

ant build

mkdir -p $out

tar --strip-components=1 -zxvf out/artifacts/ideaIC-111.SNAPSHOT.tar.gz -C $out

patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" $out/bin/${notifierToPatch}

# Create desktop item.
mkdir -p $out/share/applications
cp $out/bin/idea_CE128.png $out/share/applications/
cp ${desktopItem}/share/applications/* $out/share/applications/

