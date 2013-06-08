#!/var/run/current-system/bin/bash

# Take the list of files from the main package, ooo.lst.in

cat <<EOF
[
EOF

read file
while read file; do
  if [[ "$file" == @* ]]; then
    break
  fi
  echo '{'
  echo "  name = \"${file:33}\";"
  echo "  md5 = \"${file:0:32}\";"
  echo '}'
done

echo ']'
