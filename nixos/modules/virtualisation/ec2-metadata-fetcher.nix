{ targetRoot, wgetExtraOptions }:
''
  metaDir=${targetRoot}etc/ec2-metadata
  mkdir -m 0755 -p "$metaDir"

  echo "getting EC2 instance metadata..."

  wget ${wgetExtraOptions} -O "$metaDir/ami-manifest-path" http://169.254.169.254/1.0/meta-data/ami-manifest-path
  wget ${wgetExtraOptions} -O "$metaDir/user-data" http://169.254.169.254/1.0/user-data && chmod 600 "$metaDir/user-data"
  wget ${wgetExtraOptions} -O "$metaDir/hostname" http://169.254.169.254/1.0/meta-data/hostname
  wget ${wgetExtraOptions} -O "$metaDir/public-keys-0-openssh-key" http://169.254.169.254/1.0/meta-data/public-keys/0/openssh-key
''
