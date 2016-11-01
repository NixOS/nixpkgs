#!/bin/sh -e
PATH="${coreutils}/bin:${gzip}/bin"

name_pattern="^Package:[[:space:]]+${target}$"
filename_pattern="^Filename:[[:space:]]+([^[:space:]]+)$"
sha256_pattern="^SHA256:[[:space:]]+([[:xdigit:]]{64})$"

mkdir "${out}"
unset in_package has_filename has_sha256
while read line; do
  if [[ -z "${in_package}" ]]; then
    if [[ $line =~ $name_pattern ]]; then
      in_package=yes
    fi
  else
    if [[ $line =~ $filename_pattern ]]; then
      echo -n "${BASH_REMATCH[1]}" > "${out}/filename"
      has_filename=yes
    elif [[ $line =~ $sha256_pattern ]]; then
      echo -n "${BASH_REMATCH[1]}" > "${out}/sha256"
      has_sha256=yes
    fi
    [[ "${has_filename}" && "${has_sha256}" ]] && break
  fi
done < <( zcat "${packages}" )
