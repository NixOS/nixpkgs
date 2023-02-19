# FIXME aria2c has no manpage in nixpkgs
# https://aria2.github.io/manual/en/html/aria2c.html

{ lib
, stdenvNoCC
, fetchFromGitHub
, aria2
, cacert
, torrenttools
, jq
, unixtools
}:

{
  btih,
  #torrentFile ? "", # TODO implement
  sha256 ? "",
  hash ? "",
  name ? "",
  file ? "", # single file -> flat hash
  files ? [], # one or more files -> recursive hash (default)
  singleFile ? false, # single file without file name # TODO implement
  trackers ? [],
  extraTrackers ? [],
  doUpload ? false,
  fileAllocation ? "falloc", # https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-file-allocation
  # TODO is prealloc better for hard disks?
  # at least prealloc makes sure we have enough disk space
  # but there is a bug in aria where too many files are created
  # so prealloc will use more space than needed ...
  # https://github.com/aria2/aria2/issues/2032
} @ attrs:

stdenvNoCC.mkDerivation rec {

  builder = ./builder.sh;
  ariaCommandFile = ./ariacommand.sh;

  nativeBuildInputs = [
    aria2
    torrenttools
    jq
    unixtools.xxd
  ];

  files = attrs.files or (if (file != "") then [file] else []);
  name = attrs.name or (if (file != "") then (builtins.baseNameOf file) else "btih-${btih}");

  # TODO allow passing trackerslist as string
  trackerslistFile =
    if (trackers != [])
    then
    (builtins.writeFile "trackerslist.txt" (builtins.concatStringsSep "\n" trackers))
    else
    (fetchFromGitHub {
      # https://github.com/ngosang/trackerslist
      # using trackers by IP address to avoid DNS blocking
      owner = "ngosang";
      repo = "trackerslist";
      rev = "8ba874e69da0532166644922ea207da3084dff66"; # 2023-02-18
      sha256 = "sha256-QCE7gDtDBLLpFgGWa3r/1YOz16dTXKx6rYy8m0DCH8k=";
    }) + "/trackers_best_ip.txt"; # 16 trackers
    #}) + "/trackers_all_ip.txt"; # 97 trackers

  extraTrackerslistFile =
    if (extraTrackers != [])
    then
    (builtins.writeFile "trackerslist.txt" (builtins.concatStringsSep "\n" extraTrackers))
    else
    "";

  outputHashMode = if (singleFile == true || file != "") then "flat" else "recursive";
  outputHashAlgo = if (builtins.hasAttr "sha256" attrs) then "sha256" else builtins.head (builtins.split "[:-]" hash);
  outputHash = attrs.sha256 or (
    let hash2 = attrs.hash or (throw "sha256 or hash is required"); in
    if hash2 != "" then hash2 else (
        builtins.trace "warning: found empty hash, assuming '${lib.fakeHash}'"
      lib.fakeHash));

  inherit btih fileAllocation singleFile;

  caCertificate = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  requestedFile = file;
  requestedFilesArray = lib.toShellVar "requestedFiles" files;
  passAsFile = [
    "requestedFilesArray"
  ];

  # todo: use impure envs for ports?
  listenPort = 6881;
  dhtListenPort = 6881;
  summaryInterval = 4; # show progress every N seconds
  enableDHT = true;
}
