metaDir=/etc/ec2-metadata
mkdir -p "$metaDir"
chmod 0755 "$metaDir"
rm -f "$metaDir/*"

# See: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-metadata-v2-how-it-works.html
imds_ipv4_addr="169.254.169.254"
imds_ipv6_addr="[fd00:ec2::254]"

# modified by get_imds_token()
IMDS_USE_IPV6=false

# formats the URL for the IMDSv2 service
# based on connectivity to ipv4 vs ipv6
imds_url() {
    # replace path's leading slash with nothing
    path=$(echo "$@" | sed 's|^/||')

    if [ "$IMDS_USE_IPV6" = true ]; then
        echo "http://${imds_ipv6_addr}/${path}"
    else
        echo "http://${imds_ipv4_addr}/${path}"
    fi
}

# tests for both ipv4 and ipv6 connectivity to IMDSv2
# then retrieves a token and configures the rest of
# the script to use whichever address was available
get_imds_token() {
  # use a longer retry time to test for both ipv4 and ipv6 connectivity
  token=""

  # first test ipv4
  token=$(
    curl \
      --silent \
      --globoff \
      --show-error \
      --retry 10 \
      --retry-delay 1 \
      --retry-connrefused \
      --fail \
      -X PUT \
      --connect-timeout 1 \
      -H "X-aws-ec2-metadata-token-ttl-seconds: 600" \
      http://$imds_ipv4_addr/latest/api/token
  )

  if [ "x$token" == "x" ]; then
    # ipv4 failed, try ipv6
    IMDS_USE_IPV6=true
    token=$(
      curl \
        --silent \
        --globoff \
        --show-error \
        --retry 10 \
        --retry-delay 1 \
        --retry-connrefused \
        --fail \
        -X PUT \
        --connect-timeout 1 \
        -H "X-aws-ec2-metadata-token-ttl-seconds: 600" \
        http://$imds_ipv6_addr/latest/api/token
    )
  fi

  if [ "x$token" == "x" ]; then
    # indicate failure
    return 1
  fi

  echo "$token"
}

preflight_imds_token() {
  # retry-delay of 1 selected to give the system a second to get going,
  # but not add a lot to the bootup time
  curl \
    --silent \
    --globoff \
    --show-error \
    --retry 5 \
    --retry-delay 1 \
    --retry-connrefused \
    --fail \
    --connect-timeout 1 \
    -H "X-aws-ec2-metadata-token: $IMDS_TOKEN" \
    -o /dev/null \
    $(imds_url /latest/meta-data/instance-id)
}

try=1
while [ $try -le 3 ]; do
  echo "(attempt $try/3) getting an EC2 instance metadata service v2 token..."
  IMDS_TOKEN=$(get_imds_token) && break
  try=$((try + 1))
  sleep 1
done

if [ "$IMDS_TOKEN" == "" ]; then
  echo "failed to fetch an IMDS2v token."
  exit 1
fi

try=1
last_exit_code=""
while [ $try -le 10 ]; do
  echo "(attempt $try/10) validating the EC2 instance metadata service v2 token..."
  preflight_imds_token
  last_exit_code="$?"
  if [ "$last_exit_code" -eq 0 ]; then
    break
  fi
  try=$((try + 1))
  sleep 1
done

if [ "$last_exit_code" -ne 0 ]; then
  echo "failed to validate the IMDS2v token."
  exit 1
fi

echo "getting EC2 instance metadata..."

get_imds() {
  # --fail to avoid populating missing files with 404 HTML response body
  # || true to allow the script to continue even when encountering a 404
  curl \
      --silent \
      --globoff \
      --show-error \
      --retry 3 \
      --retry-delay 1 \
      --retry-connrefused \
      --fail \
      --header "X-aws-ec2-metadata-token: $IMDS_TOKEN" \
      "$@" || true
}

get_imds -o "$metaDir/ami-manifest-path" $(imds_url /latest/meta-data/ami-manifest-path)
(umask 077 && get_imds -o "$metaDir/user-data" $(imds_url /latest/user-data))
get_imds -o "$metaDir/hostname" $(imds_url /latest/meta-data/hostname)
get_imds -o "$metaDir/public-keys-0-openssh-key" $(imds_url /latest/meta-data/public-keys/0/openssh-key)
