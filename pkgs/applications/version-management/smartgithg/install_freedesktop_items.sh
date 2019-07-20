#!@shell@

inBinDir=$1
out=$2

cat $inBinDir/add-menuitem.sh | \
sed -re 's#xdg-icon-resource[ ]+install[ ]+--size[ ]+([0-9]+)[ ]+("[^"]+")[ ]+([$0-9a-zA-Z_]+)#mkdir -p '${out}'/share/icons/hicolor/\1x\1/apps \&\& cp \2 '${out}'/share/icons/hicolor/\1x\1/apps/\3\.png #' | \
sed -re 's#xdg-desktop-menu[ ]+install[ ]+([$0-9a-zA-Z_]+)#mkdir -p '${out}'/share/applications \&\& cp \1 '${out}'/share/applications/#' | \
sed -re 's#Exec="[^"]+"#Exec=smartgit#' |
sed -re 's#SMARTGIT_BIN=.*#'SMARTGIT_BIN=${inBinDir}'#' \
| bash
