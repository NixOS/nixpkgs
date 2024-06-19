{ targetRoot, wgetExtraOptions }:

# OpenStack's metadata service aims to be EC2-compatible. Where
# possible, try to keep the set of fetched metadata in sync with
# ./ec2-metadata-fetcher.nix .
''
  metaDir=${targetRoot}etc/ec2-metadata
  mkdir -m 0755 -p "$metaDir"
  rm -f "$metaDir/*"

  echo "getting instance metadata..."

  wget_imds() {
    wget ${wgetExtraOptions} "$@"
  }

  wget_imds -O "$metaDir/ami-manifest-path" http://169.254.169.254/1.0/meta-data/ami-manifest-path || true
  # When no user-data is provided, the OpenStack metadata server doesn't expose the user-data route.
  (umask 077 && wget_imds -O "$metaDir/user-data" http://169.254.169.254/1.0/user-data || rm -f "$metaDir/user-data")
  wget_imds -O "$metaDir/hostname" http://169.254.169.254/1.0/meta-data/hostname || true
  wget_imds -O "$metaDir/public-keys-0-openssh-key" http://169.254.169.254/1.0/meta-data/public-keys/0/openssh-key || true
''
