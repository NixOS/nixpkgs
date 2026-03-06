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
  urlRegexp = ".*xt=urn:bt[im]h:([^&]{64}|[^&]{40}).*";
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

  setupScript = ''
    export HOME=$TMP
    mkdir -p $out
    downloadedDirectory=${
      if flatten' then "$(mktemp -d $out/downloadedDirectory.XXXXXXXXXX)" else "$out"
    }
    export downloadedDirectory # See https://www.shellcheck.net/wiki/SC2155
    port="$(shuf -n 1 -i 49152-65535)"
  '';

  flattenScript = ''
    (
      shopt -s dotglob nullglob
      downloadedFiles=($downloadedDirectory/*)
      if [[ ''${#downloadedFiles[@]} -eq 0 ]]; then
        echo "Failed to download any files."
        exit 1
      elif [[ ''${#downloadedFiles[@]} -eq 1 ]] && [[ -d "$downloadedFiles" ]]; then
        # Flatten the directory, so that only the torrent contents are in $out,
        # not the folder name
        mv -v "$downloadedFiles"/* $out
      else
        # Either we downloaded a single (regular) file, or we downloaded
        # multiple files/directories. We can't flatten, so we move them to
        # $out.
        mv -v "''${downloadedFiles[@]}" $out
      fi
      rm -v -rf $downloadedDirectory
    )
  '';

  finishScript = ''
    ${postUnpack}
    ${lib.optionalString flatten' flattenScript}
    ${postFetch}
  '';

  transmissionFinishScript = writeShellScript "fetch-bittorrent-done.sh" ''
    ${finishScript}
    kill $PPID
  '';
  jsonConfig = (formats.json { }).generate "jsonConfig" config;

  # https://github.com/NixOS/nixpkgs/issues/432001
  #
  # For a while, the transmission backend would put the downloaded torrent in
  # the output directory, but whether the rqbit backend would put the output in
  # the output directory or a subdirectory depended on the version of rqbit.
  # We want to standardise on a single behaviour, but give users of
  # fetchtorrent with the rqbit backend some warning that the behaviour might
  # be unexpected, particularly since we can't know what behaviour users might
  # be expecting at this point, and they probably wouldn't notice a change
  # straight away because the results are fixed-output derivations.
  #
  # This warning was introduced for 25.11, so we can remove handling of the
  # `flatten` argument once that release is no longer supported.
  warnings =
    if backend == "rqbit" && flatten == null then
      [
        ''
          `fetchtorrent` with the rqbit backend may or may not have the
          downloaded files stored in a subdirectory of the output directory.
          Verify which behaviour you need, and set the `flatten` argument to
          `fetchtorrent` accordingly.

          The `flatten = false` behaviour will still produce a warning, as this
          behaviour is deprecated.  It is only available with the "rqbit" backend
          to provide temporary support for users who are relying on the
          previous incorrect behaviour.  For a warning-free evaluation, use
          `flatten = true`.
        ''
      ]
    else if flatten == false then
      [
        ''
          `fetchtorrent` with `flatten = false` is deprecated and will be
          removed in a future release.
        ''
      ]
    else
      [ ];
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
        ${setupScript}
        mkdir -p $HOME/.config/transmission
        cp ${jsonConfig} $HOME/.config/transmission/settings.json
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
        ${setupScript}
        rqbit \
            --disable-dht-persistence \
            --http-api-listen-addr "127.0.0.1:$port" \
            download \
            -o "$downloadedDirectory" \
            --exit-on-finish \
            "$url"
        ${finishScript}
      ''
  )
