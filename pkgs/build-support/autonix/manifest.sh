#!@bash@/bin/bash

@coreutils@/bin/mkdir tmp; cd tmp

@wget@/bin/wget -nH -r -c --no-parent $*

cat >../manifest.json <<EOF
[
EOF

workdir=$(pwd)
sep=""

@findutils@/bin/find . | while read path; do
    if [[ -f "${path}" ]]; then
        [[ -n "${sep}" ]] && echo "$sep" >>../manifest.json
        url="${path:2}"
        # Sanitize file name
        filename=$(@coreutils@/bin/basename "${path}" | tr '@' '_')
        nameversion="${filename%.tar.*}"
        name="${nameversion%-*}"
        dirname=$(@coreutils@/bin/dirname "${path}")
        mv "${workdir}/${path}" "${workdir}/${dirname}/${filename}"
        # Prefetch and hash source file
        sha256=$(@nix@/bin/nix-prefetch-url "file://${workdir}/${dirname}/${filename}")
        store=$(@nix@/bin/nix-store --print-fixed-path sha256 "$sha256" "$filename")
        cat >>../manifest.json <<EOF
  {
    "name": "${nameversion}",
    "store": "${store}",
    "src": {
      "url": "${url}",
      "sha256": "${sha256}",
      "name": "${filename}"
    }
  }
EOF
        sep=","
    fi
done

echo "]" >>../manifest.json

cd ..
