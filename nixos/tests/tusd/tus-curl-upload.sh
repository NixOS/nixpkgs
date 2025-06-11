#!/usr/bin/env bash

# Adapted from:
# - https://github.com/tus/tus.io/issues/96

if [ ! -f "${1}" ]; then
  echo -e "\n\033[1;31m✘\033[0m First argument needs to be an existing file.\n"
  exit 1
fi

if [ -z "${2}" ]; then
  echo -e "\n\033[1;31m✘\033[0m Second argument needs to be the TUS server's URL.\n"
  exit 1
fi

file=${1}
TUS_URL=${2}
filename=$(basename "${file}" | base64)
filesize="$(wc -c <"${file}")"

# Apparently 'Location: ..' is terminated by CRLF. grep and awk faithfully
# preserve the line ending, and the shell's $() substitution strips off the
# final LF leaving you with a string that just ends with a CR.
#
# When the CR is printed, the cursor moves to the beginning of the line and
# whatever gets printed next overwrites what was there.
# ... | tr -d '\015'
location=$(curl \
  --silent --show-error \
  -I \
  -X POST \
  -H "Tus-Resumable: 1.0.0" \
  -H "Content-Length: 0" \
  -H "Upload-Length: ${filesize}" \
  -H "Upload-Metadata: name ${filename}" \
  "${TUS_URL}" | grep 'Location:' | awk '{print $2}' | tr -d '\015')

if [ -n "${location}" ]; then
  curl \
    -X PATCH \
    -H "Tus-Resumable: 1.0.0" \
    -H "Upload-Offset: 0" \
    -H "Content-Length: ${filesize}" \
    -H "Content-Type: application/offset+octet-stream" \
    --data-binary "@${file}" \
    "${location}" -v
else
  echo -e "\n\033[1;31m✘\033[0m File creation failed..\n"
  exit 1
fi
