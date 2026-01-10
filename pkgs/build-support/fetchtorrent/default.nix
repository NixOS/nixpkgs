{
  lib,
  runCommand,
  transmission_4,
  rqbit,
  writeShellScript,
  formats,
  cacert,
  rsync,
}:
let
  urlRegexp = ''.*xt=urn:bt[im]h:([^&]{64}|[^&]{40}).*'';
in
{
  url,
  name ?
    if (builtins.match urlRegexp url) == null then
      "bittorrent"
    else
      "bittorrent-" + builtins.head (builtins.match urlRegexp url),
  config ? { },
  hash,
  backend ? "transmission",
  recursiveHash ? true,
  flatten ? null,
  postFetch ? "",
  postUnpack ? "",
  meta ? { },
}:
let
  # Default to flattening if no flatten argument was specified.
  flatten' = if flatten == null then true else flatten;

  transmissionFinishScript = writeShellScript "fetch-bittorrent-done.sh" ''
    ${postUnpack}
    # Flatten the directory, so that only the torrent contents are in $out, not
    # the folder name
    shopt -s dotglob
    mv -v $downloadedDirectory/*/* $out
    rm -v -rf $downloadedDirectory
    unset downloadedDirectory
    ${postFetch}
    kill $PPID
  '';
  jsonConfig = (formats.json { }).generate "jsonConfig" config;
in
assert lib.assertMsg (config != { } -> backend == "transmission") ''
  json config for configuring fetchtorrent only works with the transmission backend
'';
assert lib.assertMsg (backend == "transmission" -> flatten') ''
  `flatten = false` is only supported by the rqbit backend for fetchtorrent
'';
runCommand name
  {
    inherit meta;
    nativeBuildInputs = [
      cacert
    ]
    ++ (
      if (backend == "transmission") then
        [ transmission_4 ]
      else if (backend == "rqbit") then
        [ rqbit ]
      else
        throw "rqbit or transmission are the only available backends for fetchtorrent"
    );
    outputHashAlgo = if hash != "" then null else "sha256";
    outputHash = hash;
    outputHashMode = if recursiveHash then "recursive" else "flat";

    # url will be written to the derivation, meaning it can be parsed and utilized
    # by external tools, such as tools that may want to seed fetchtorrent calls
    # in nixpkgs
    inherit url;
  }
  (
    if (backend == "transmission") then
      ''
        export HOME=$TMP
        export downloadedDirectory=$out/downloadedDirectory
        mkdir -p $downloadedDirectory
        mkdir -p $HOME/.config/transmission
        cp ${jsonConfig} $HOME/.config/transmission/settings.json
        port="$(shuf -n 1 -i 49152-65535)"
        function handleChild {
          # This detects failures and logs the contents of the transmission fetch
          find $out
          exit 0
        }
        trap handleChild CHLD
        transmission-cli \
            --port "$port" \
            --portmap \
            --finish ${transmissionFinishScript} \
            --download-dir "$downloadedDirectory" \
            "$url"
      ''
    else
      ''
        export HOME=$TMP
      ''
      + lib.optionalString flatten' ''
        downloadedDirectory=$out/downloadedDirectory
        mkdir -p $downloadedDirectory
      ''
      + lib.optionalString (!flatten') ''
        downloadedDirectory=$out
      ''
      + ''
        port="$(shuf -n 1 -i 49152-65535)"

        rqbit \
            --disable-dht-persistence \
            --http-api-listen-addr "127.0.0.1:$port" \
            download \
            -o "$downloadedDirectory" \
            --exit-on-finish \
            "$url"

        ${postUnpack}
      ''
      + lib.optionalString flatten' ''
        # Flatten the directory, so that only the torrent contents are in $out,
        # not the folder name
        shopt -s dotglob
        mv -v $downloadedDirectory/*/* $out
        rm -v -rf $downloadedDirectory
        unset downloadedDirectory
      ''
      + ''
        ${postFetch}
      ''
  )
