{ curl, targetRoot, wgetExtraOptions }:
# Note: be very cautious about dependencies, each dependency grows
# the closure of the initrd. Ideally we would not even require curl,
# but there is no reasonable way to send an HTTP PUT request without
# it. Note: do not be fooled: the wget referenced in this script
# is busybox's wget, not the fully featured one with --method support.
#
# Make sure that every package you depend on here is already listed as
# a channel blocker for both the full-sized and small channels.
# Otherwise, we risk breaking user deploys in released channels.
#
# Also note: OpenStack's metadata service for its instances aims to be
# compatible with the EC2 IMDS. Where possible, try to keep the set of
# fetched metadata in sync with ./openstack-metadata-fetcher.nix .
''
  metaDir=${targetRoot}etc/ec2-metadata
  mkdir -m 0755 -p "$metaDir"
  rm -f "$metaDir/*"

  get_imds_token() {
    # retry-delay of 1 selected to give the system a second to get going,
    # but not add a lot to the bootup time
    ${curl}/bin/curl \
      -v \
      --retry 3 \
      --retry-delay 1 \
      --fail \
      -X PUT \
      --connect-timeout 1 \
      -H "X-aws-ec2-metadata-token-ttl-seconds: 600" \
      http://169.254.169.254/latest/api/token
  }

  preflight_imds_token() {
    # retry-delay of 1 selected to give the system a second to get going,
    # but not add a lot to the bootup time
    ${curl}/bin/curl \
      -v \
      --retry 3 \
      --retry-delay 1 \
      --fail \
      --connect-timeout 1 \
      -H "X-aws-ec2-metadata-token: $IMDS_TOKEN" \
      http://169.254.169.254/1.0/meta-data/instance-id
  }

  try=1
  while [ $try -le 3 ]; do
    echo "(attempt $try/3) getting an EC2 instance metadata service v2 token..."
    IMDS_TOKEN=$(get_imds_token) && break
    try=$((try + 1))
    sleep 1
  done

  if [ "x$IMDS_TOKEN" == "x" ]; then
    echo "failed to fetch an IMDS2v token."
  fi

  try=1
  while [ $try -le 10 ]; do
    echo "(attempt $try/10) validating the EC2 instance metadata service v2 token..."
    preflight_imds_token && break
    try=$((try + 1))
    sleep 1
  done

  echo "getting EC2 instance metadata..."

  wget_imds() {
    wget ${wgetExtraOptions} --header "X-aws-ec2-metadata-token: $IMDS_TOKEN" "$@";
  }

  wget_imds -O "$metaDir/ami-manifest-path" http://169.254.169.254/1.0/meta-data/ami-manifest-path
  (umask 077 && wget_imds -O "$metaDir/user-data" http://169.254.169.254/1.0/user-data)
  wget_imds -O "$metaDir/hostname" http://169.254.169.254/1.0/meta-data/hostname
  wget_imds -O "$metaDir/public-keys-0-openssh-key" http://169.254.169.254/1.0/meta-data/public-keys/0/openssh-key
''
