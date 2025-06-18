{
  lib,
  runCommand,
  transmission_3_noSystemd,
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
  config ?
    if (backend == "transmission") then
      { }
    else
      throw "json config for configuring fetchFromBitorrent only works with the transmission backend",
  hash,
  backend ? "transmission",
  recursiveHash ? true,
  postFetch ? "",
  postUnpack ? "",
  meta ? { },
}:
let
  afterSuccess = writeShellScript "fetch-bittorrent-done.sh" ''
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
runCommand name
  {
    inherit meta;
    nativeBuildInputs =
      [ cacert ]
      ++ (
        if (backend == "transmission") then
          [ transmission_3_noSystemd ]
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
        function handleChild {
          # This detects failures and logs the contents of the transmission fetch
          find $out
          exit 0
        }
        trap handleChild CHLD
        transmission-cli --port $(shuf -n 1 -i 49152-65535) --portmap --finish ${afterSuccess} --download-dir $downloadedDirectory --config-dir "$HOME"/.config/transmission "$url"
      ''
    else
      ''
        export HOME=$TMP
        rqbit --disable-dht-persistence --http-api-listen-addr "127.0.0.1:$(shuf -n 1 -i 49152-65535)" download -o $out --exit-on-finish "$url"
      ''
  )
