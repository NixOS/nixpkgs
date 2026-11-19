metaDir=/etc/ec2-metadata
mkdir -p "$metaDir"
chmod 0755 "$metaDir"
rm -f "$metaDir/*"

IMDS_ENDPOINTS="http://169.254.169.254 http://[fd00:ec2::254]"
IMDS_BASE_URL="http://169.254.169.254"
IMDS_TOKEN=""

# IMDS can take a moment to answer after launch, so keep retrying, but give up
# after 30 seconds so that instances with IMDS disabled or blocked boot quickly.
deadline=$((SECONDS + 30))

imds_curl_flags=(--silent --show-error --fail --connect-timeout 1 --max-time 5)

imds_curl() {
  curl "${imds_curl_flags[@]}" "$@"
}

# Also cuts curl's own retries short at the deadline.
imds_curl_until_deadline() {
  local left=$((deadline - SECONDS))
  # 28 is curl's exit code for timeouts
  [ "$left" -gt 0 ] || return 28
  timeout "$left" curl "${imds_curl_flags[@]}" "$@"
}

get_imds_token() {
  local endpoint=$1
  # retry-delay of 1 selected to give the system a second to get going,
  # but not add a lot to the bootup time
  imds_curl_until_deadline \
    --retry 3 \
    --retry-delay 1 \
    -X PUT \
    -H "X-aws-ec2-metadata-token-ttl-seconds: 600" \
    "$endpoint/latest/api/token"
}

preflight_imds_token() {
  local endpoint=$1
  # retry-delay of 1 selected to give the system a second to get going,
  # but not add a lot to the bootup time
  imds_curl_until_deadline \
    --retry 3 \
    --retry-delay 1 \
    -H "X-aws-ec2-metadata-token: $IMDS_TOKEN" \
    -o /dev/null \
    "$endpoint/1.0/meta-data/instance-id"
}

try=1
while [ $try -le 3 ] && [ $SECONDS -lt $deadline ]; do
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

reachable=""
try=1
while [ $try -le 10 ] && [ $SECONDS -lt $deadline ]; do
  echo "(attempt $try/10) validating the EC2 instance metadata service v2 token..."
  preflight_imds_token "$IMDS_BASE_URL" && reachable=1 && break
  try=$((try + 1))
  sleep 1
done

if [ -z "$reachable" ]; then
  echo "the EC2 instance metadata service is unreachable, not fetching instance metadata."
  exit 1
fi

echo "getting EC2 instance metadata..."

get_imds() {
  # --fail to avoid populating missing files with 404 HTML response body
  # || true to allow the script to continue even when encountering a 404
  imds_curl --header "X-aws-ec2-metadata-token: $IMDS_TOKEN" "$@" || true
}

try_decompress() {
  local temp ftype decompress_cmd
  if [ ! -s "$1" ]; then
    return
  fi
  ftype=$(file --brief "$1")
  case $ftype in
    gzip*)       decompress_cmd=zcat ;;
    bzip2*)      decompress_cmd=bzcat ;;
    XZ*)         decompress_cmd=xzcat ;;
    Zstandard*)  decompress_cmd=zstdcat ;;
    lzip*)       decompress_cmd="lzip -dc" ;;
    *)           return ;;
  esac
  echo "decompressing: $1"
  temp=$(mktemp)
  if $decompress_cmd "$1" > "$temp"; then
    mv "$temp" "$1"
  else
    echo "failed to decompress: $1"
    rm -f "$temp"
  fi
}

get_imds -o "$metaDir/ami-manifest-path" "$IMDS_BASE_URL/1.0/meta-data/ami-manifest-path"
(umask 077 && get_imds -o "$metaDir/user-data" "$IMDS_BASE_URL/1.0/user-data" && try_decompress "$metaDir/user-data")
get_imds -o "$metaDir/hostname" "$IMDS_BASE_URL/1.0/meta-data/hostname"
get_imds -o "$metaDir/public-keys-0-openssh-key" "$IMDS_BASE_URL/1.0/meta-data/public-keys/0/openssh-key"
