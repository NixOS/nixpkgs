runtime_home="${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja"

mkdir -p "$runtime_home"

for src in folder random table; do
  if [[ ! -d "$runtime_home/$src" ]]; then
    cp -r $out/share/beatoraja/$src "$runtime_home"
    chmod -R u+w "$runtime_home/$src"
  fi
done

lnSrc() {
  if [[ -e "$runtime_home/$1" ]] then
    if [[ -L "$runtime_home/$1" ]]; then
      rm "$runtime_home/$1"
    else
      mv "$runtime_home/$1" "$runtime_home/$1.bak"
    fi
  fi
  mkdir -p "$runtime_home/$(dirname $1)"
  ln -s $out/share/beatoraja/$1 "$runtime_home/$1"
}

lnSrc defaultsound
lnSrc font
lnSrc ir
for src in $out/share/beatoraja/{skin,sound,bgm}/*; do
  lnSrc "$(basename $(dirname $src))/$(basename $src)"
done

cd "$runtime_home"
