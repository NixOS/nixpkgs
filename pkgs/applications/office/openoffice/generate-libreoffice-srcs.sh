#!/var/run/current-system/bin/bash

# Take the list of files from the main package, ooo.lst.in

echo '{fetchurl} : ['

while read a; do

  URL=http://dev-www.libreoffice.org/src/$a

  MD5=${a::32}
  echo '(fetchurl {'
  echo "  url = \"$URL\";"
  echo "  md5 = \"$MD5\";"
  echo '})'
done

echo ']'
