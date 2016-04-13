# Reference: docker src contrib/download-frozen-image.sh

source $stdenv/setup

# Curl flags to handle redirects, not use EPSV, handle cookies for
# servers to need them during redirects, and work on SSL without a
# certificate (this isn't a security problem because we check the
# cryptographic hash of the output anyway).
curl=$(command -v curl)
curl() {
  [[ -n ${token:-} ]] && set -- -H "Authorization: Token $token" "$@"
  $curl \
    --location --max-redirs 20 \
    --retry 3 \
    --fail \
    --disable-epsv \
    --cookie-jar cookies \
    --insecure \
    $curlOpts \
    $NIX_CURL_FLAGS \
    "$@"
}

fetchLayer() {
    local url="$1"
    local dest="$2"
    local curlexit=18;

    # if we get error code 18, resume partial download
    while [ $curlexit -eq 18 ]; do
        # keep this inside an if statement, since on failure it doesn't abort the script
        if curl -C - "$url" --output "$dest"; then
            return 0
        else
            curlexit=$?;
        fi
    done

    return $curlexit
}

headers=$(curl -o /dev/null -D- -H 'X-Docker-Token: true' \
          "$indexUrl/$registryVersion/repositories/$imageName/images")

header() {
  grep $1 <<< "$headers" | tr -d '\r' | cut -d ' ' -f 2
}

# this only takes the first endpoint, more may be provided
# https://docs.docker.com/v1.6/reference/api/docker-io_api/
if ! registryUrl=$(header X-Docker-Endpoints); then
  echo "error: index returned no endpoint"
  exit 1
fi
baseUrl="https://$registryUrl/$registryVersion"

token="$(header X-Docker-Token || true)";

if [ -z "$imageId" ]; then
    imageId="$(curl "$baseUrl/repositories/$imageName/tags/$imageTag")"
    imageId="${imageId//\"/}"
    if [ -z "$imageId" ]; then
        echo "error: no image ID found for ${imageName}:${imageTag}"
        exit 1
    fi

    echo "found image ${imageName}:${imageTag}@$imageId"
fi

mkdir -p $out

jshon -n object \
  -n object -s "$imageId" -i "$imageTag" \
  -i "$imageName" > $out/repositories

curl "$baseUrl/images/$imageId/ancestry" -o ancestry.json

layerIds=$(jshon -a -u < ancestry.json)
for layerId in $layerIds; do
    echo "fetching layer $layerId"
    
    mkdir "$out/$layerId"
    echo '1.0' > "$out/$layerId/VERSION"
    curl "$baseUrl/images/$layerId/json" | python $detjson > "$out/$layerId/json"
    fetchLayer "$baseUrl/images/$layerId/layer" "$out/$layerId/layer.tar"
done
