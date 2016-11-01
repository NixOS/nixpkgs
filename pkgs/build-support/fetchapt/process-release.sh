#!/bin/sh -e
pattern="^([[:xdigit:]]{64})[[:space:]]+[[:digit:]]+[[:space:]]+${target}$"
while read line; do
  if [[ $line =~ $pattern ]]; then
    echo -n "${BASH_REMATCH[1]}" >> ${out}
    break
  fi
done < ${release}
