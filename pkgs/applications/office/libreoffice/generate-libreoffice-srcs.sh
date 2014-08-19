#!/run/current-system/sw/bin/bash

# Take the list of files from the main package, ooo.lst.in

cat <<EOF
[
EOF

write_entry(){
  echo '{'
  echo "  name = \"${name}\";"
  echo "  md5 = \"${md5}\";"
  echo "  brief = ${brief};"
  echo '}'
}

while read line; do
  case "$line" in
    \#*)
      echo Skipping comment: "$line" >&2;
      ;;
    *_MD5SUM\ :=*)
      read tbline;
      line=${line##* };
      tbline=${tbline##* };
      md5=$line
      name=$tbline;
      brief=true;
      write_entry;
      ;;
    *_TARBALL\ :=*)
      line=${line##* };
      md5=${line:0:32};
      name=${line:33};
      brief=false;
      write_entry;
      ;;
    *)
      echo Skipping: "$line" >&2;
      ;;
  esac
done

echo ']'
