metaDir=/etc/ec2-metadata
mkdir -p "$metaDir"
chmod 0755 "$metaDir"
rm -f "$metaDir/*"

IMDS_ENDPOINTS="http://169.254.169.254 http://[fd00:ec2::254]"
IMDS_BASE_URL="http://169.254.169.254"
IMDS_TOKEN=""

get_imds_token() {
  endpoint=$1
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
    "$endpoint/latest/api/token"
}

preflight_imds_token() {
  endpoint=$1
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
    "$endpoint/1.0/meta-data/instance-id"
}

try=1
while [ $try -le 3 ]; do
  echo "(attempt $try/3) getting an EC2 instance metadata service v2 token..."
  for endpoint in $IMDS_ENDPOINTS; do
    IMDS_TOKEN=$(get_imds_token "$endpoint") && IMDS_BASE_URL=$endpoint && break
  done
  if [ -n "$IMDS_TOKEN" ]; then
    break
  fi
  try=$((try + 1))
  sleep 1
done

if [ "$IMDS_TOKEN" == "" ]; then
  echo "failed to fetch an IMDSv2 token."
fi

try=1
while [ $try -le 10 ]; do
  echo "(attempt $try/10) validating the EC2 instance metadata service v2 token..."
  preflight_ok=""
  for endpoint in $IMDS_ENDPOINTS; do
    if preflight_imds_token "$endpoint"; then
      IMDS_BASE_URL=$endpoint
      preflight_ok=1
      break
    fi
  done
  if [ -n "$preflight_ok" ]; then
    break
  fi
  try=$((try + 1))
  sleep 1
done

echo "getting EC2 instance metadata..."

get_imds() {
  # --fail to avoid populating missing files with 404 HTML response body
  # || true to allow the script to continue even when encountering a 404
  curl --silent --show-error --fail --header "X-aws-ec2-metadata-token: $IMDS_TOKEN" "$@" || true
}

get_imds -o "$metaDir/ami-manifest-path" "$IMDS_BASE_URL/1.0/meta-data/ami-manifest-path"
(umask 077 && get_imds -o "$metaDir/user-data" "$IMDS_BASE_URL/1.0/user-data")
get_imds -o "$metaDir/hostname" "$IMDS_BASE_URL/1.0/meta-data/hostname"
get_imds -o "$metaDir/public-keys-0-openssh-key" "$IMDS_BASE_URL/1.0/meta-data/public-keys/0/openssh-key"
