# Note: This fetcher is used by both ./amazon-image.nix and
# ./openstack-config.nix, so we need to be compatible with both.
#
# More info about OpenStack's IMDS, including version compatibility:
# https://docs.openstack.org/nova/latest/user/metadata.html#metadata-ec2-format
{ targetRoot, wgetExtraOptions, useImdsToken ? false }:
let
  # Snippet to fetch the IMDS token, used by IMDSv2:
  # https://aws.amazon.com/blogs/security/defense-in-depth-open-firewalls-reverse-proxies-ssrf-vulnerabilities-ec2-instance-metadata-service/
  # We construct the PUT request by hand, because wget is busybox wget and can't.
  fetchImdsToken = ''
    TOKEN=$(echo -ne 'PUT /latest/api/token HTTP/1.1\r\nHost: 169.254.169.254\r\nX-aws-ec2-metadata-token-ttl-seconds: 60\r\n\r\n' | nc 169.254.169.254 80 | tail -n 1)
    wgetCmd="wget ${wgetExtraOptions} --header 'X-aws-ec2-metadata-token: $TOKEN'"
  '';
in
''
  imds=http://169.254.169.254/2009-04-04
  metaDir=${targetRoot}etc/ec2-metadata
  wgetCmd="wget ${wgetExtraOptions}"
  mkdir -m 0755 -p "$metaDir"

  echo "getting EC2 instance metadata..."

  ${if useImdsToken then fetchImdsToken else ""}

  if ! [ -e "$metaDir/ami-manifest-path" ]; then
    $wgetCmd -O "$metaDir/ami-manifest-path" $imds/meta-data/ami-manifest-path
  fi

  if ! [ -e "$metaDir/user-data" ]; then
    $wgetCmd -O "$metaDir/user-data" $imds/user-data && chmod 600 "$metaDir/user-data"
  fi

  if ! [ -e "$metaDir/hostname" ]; then
    $wgetCmd -O "$metaDir/hostname" $imds/meta-data/hostname
  fi

  if ! [ -e "$metaDir/public-ipv4" ]; then
    $wgetCmd -O "$metaDir/public-ipv4" $imds/meta-data/public-ipv4
  fi

  if ! [ -e "$metaDir/public-keys-0-openssh-key" ]; then
    $wgetCmd -O "$metaDir/public-keys-0-openssh-key" $imds/meta-data/public-keys/0/openssh-key
  fi
''
