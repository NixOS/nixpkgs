{ targetRoot, wgetExtraOptions }:
''
  imds=http://169.254.169.254/2019-10-01
  metaDir=${targetRoot}etc/ec2-metadata
  mkdir -m 0755 -p "$metaDir"

  echo "getting EC2 instance metadata..."

  # Construct the PUT request by hand, because wget is busybox wget and can't.
  TOKEN=$(echo -ne 'PUT /latest/api/token HTTP/1.1\r\nHost: 169.254.169.254\r\nX-aws-ec2-metadata-token-ttl-seconds: 60\r\n\r\n' | nc 169.254.169.254 80 | tail -n 1)
  wgetCmd="wget ${wgetExtraOptions} --header 'X-aws-ec2-metadata-token: $TOKEN'"

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
