#! @shell@
# shellcheck shell=bash

set -euo pipefail

mkdir -p ~/.local/share/sdlpop
cd ~/.local/share/sdlpop

for i in SDLPoP.ini mods; do
  [ -e $i ] || cp -r @out@/share/sdlpop/$i .
done

# Create the data symlink or update it (in case it is a symlink, else the user
# has probably tinkered with it and does not want it to be recreated).
[ ! -e data -o -L data ] && ln -sf @out@/share/sdlpop/data .

exec -a "prince" @out@/bin/.prince-bin "$@"
