#! /bin/sh

url="$1"
protocol="${url%%:*}"
path="${url#$protocol://}"
server="${path%%/*}"
basepath="${path%/*}"
relpath="${path#$server}"
 
echo "URL: $url" >&2

curl -L -k "$url" | sed -re 's/^/-/;s/[hH][rR][eE][fF]="([^"]*)"/\n+\1\n-/g' | \
  sed -e '/^-/d; s/^[+]//; /^#/d;'"s/^\\//$protocol:\\/\\/$server\\//g" | \
  sed -re 's`^[^:]*$`'"$protocol://$basepath/&\`"
