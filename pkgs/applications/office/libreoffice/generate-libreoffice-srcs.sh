#!/run/current-system/sw/bin/bash

# Ideally we would move as much as possible into derivation dependencies

# Take the list of files from the main package, ooo.lst.in

# This script wants an argument: download list file

cat <<EOF
[
EOF

write_entry(){
  echo '{'
  echo "  name = \"${name}\";"
  echo "  md5 = \"${md5}\";"
  echo "  brief = ${brief};"
  eval "echo -n \"\$additions_${name%%[-_.]*}\""
  eval "test -n \"\$additions_${name%%[-_.]*}\" && echo"
  echo '}'
}

cat "$(dirname "$0")/libreoffice-srcs-additions.sh" "$@" |
while read line; do
  case "$line" in
    EVAL\ *)
      echo "${line#* }" >&2;
      eval "${line#* }";
      ;;
    \#*)
      echo Skipping comment: "$line" >&2;
      ;;
    *_MD5SUM\ :=*)
      read tbline;
      line=${line##* };
      if [ "${tbline#*VERSION_MICRO}" != "$tbline" ]; then
         verline=${tbline##* };
         read tbline;
         tbline=${tbline##* };
         md5=$line
         name=$tbline;
         name="${name/\$([A-Z]*_VERSION_MICRO)/$verline}"
      else
         tbline=${tbline##* };
         md5=$line
         name=$tbline;
      fi
      brief=true;
      write_entry;
      ;;
    *_TARBALL\ :=*)
      line=${line##* };
      line="${line#,}"
      md5=${line:0:32};
      name=${line:33};
      name="${name%)}"
      brief=false;
      write_entry;
      ;;
    *)
      echo Skipping: "$line" >&2;
      ;;
  esac
done

echo ']'
