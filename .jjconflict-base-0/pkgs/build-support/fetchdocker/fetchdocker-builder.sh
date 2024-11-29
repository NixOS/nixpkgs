if [ -e "$NIX_ATTRS_SH_FILE" ]; then . "$NIX_ATTRS_SH_FILE"; elif [ -f .attrs.sh ]; then . .attrs.sh; fi
source "${stdenv}/setup"
echo "exporting ${repository}/${imageName} (tag: ${tag}) into ${out}"
mkdir -p "${out}"

cat <<EOF > "${out}/compositeImage.sh"
#! ${bash}/bin/bash
#
# Create a tar archive of a docker image's layers, docker image config
# json, manifest.json, and repositories json; this streams directly to
# stdout and is intended to be used in concert with docker load, i.e:
#
# ${out}/compositeImage.sh | docker load

# The first character follow the 's' command for sed becomes the
# delimiter sed will use; this makes the transformation regex easy to
# read. We feed tar a file listing the files we want in the archive,
# because the paths are absolute and docker load wants them flattened in
# the archive, we need to transform all of the paths going in by
# stripping everything *including* the last solidus so that we end up
# with the basename of the path.
${gnutar}/bin/tar \
  --transform='s=.*/==' \
  --transform="s=.*-manifest.json=manifest.json=" \
  --transform="s=.*-repositories=repositories=" \
  -c "${manifest}" "${repositories}" -T "${imageFileStorePaths}"
EOF
chmod +x "${out}/compositeImage.sh"
