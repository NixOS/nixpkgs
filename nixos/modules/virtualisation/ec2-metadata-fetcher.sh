metaDir=/etc/ec2-metadata
mkdir -m 0755 -p "$metaDir"
rm -f "$metaDir/*"

get_imds_token() {
  # retry-delay of 1 selected to give the system a second to get going,
  # but not add a lot to the bootup time
  curl \
    --silent \
    --show-error \
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
  curl \
    --silent \
    --show-error \
    --retry 3 \
    --retry-delay 1 \
    --fail \
    --connect-timeout 1 \
    -H "X-aws-ec2-metadata-token: $IMDS_TOKEN" \
    -o /dev/null \
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

get_imds() {
  # --fail to avoid populating missing files with 404 HTML response body
  # || true to allow the script to continue even when encountering a 404
  curl --silent --show-error --fail --header "X-aws-ec2-metadata-token: $IMDS_TOKEN" "$@" || true
}

get_imds -o "$metaDir/ami-manifest-path" http://169.254.169.254/1.0/meta-data/ami-manifest-path
(umask 077 && get_imds -o "$metaDir/user-data" http://169.254.169.254/1.0/user-data)
get_imds -o "$metaDir/hostname" http://169.254.169.254/1.0/meta-data/hostname
get_imds -o "$metaDir/public-keys-0-openssh-key" http://169.254.169.254/1.0/meta-data/public-keys/0/openssh-key
