{
  lib,
  findutils,
  live-server,
  parallel,
  rsync,
  watchexec,
  writeShellScriptBin,
  # arguments to `nix-build`, e.g. `"foo.nix -A bar"`
  buildArgs ? "",
  # what path to open a browser at
  open ? "/index.html",
}:
let
  # The following would have been simpler:
  # 1. serve from `$serve`
  # 2. pass each build a `--out-link $serve/result`
  # But that way live-server does not seem to detect changes and therefore no
  # auto-reloads occur.
  # Instead, we copy the contents of each build to the `$serve` directory.
  # Using rsync here, instead of `cp`, to get as close to an atomic
  # directory copy operation as possible. `--delay-updates` should
  # also go towards that.
  build-and-copy = writeShellScriptBin "build-and-copy" ''
    set -euxo pipefail

    set +e
    stderr=$(2>&1 nix-build --out-link $out_link ${buildArgs})
    exit_status=$?
    set -e

    if [ $exit_status -eq 0 ];
    then
      # setting permissions to be able to clean up
      ${lib.getExe rsync} \
        --recursive \
        --chmod=u=rwX \
        --delete-before \
        --delay-updates \
        --links \
        $out_link/ \
        $serve/
    fi
  '';

  # https://watchexec.github.io/
  watcher = writeShellScriptBin "watcher" ''
    set -euxo pipefail

    ${lib.getExe watchexec} \
      --shell=none \
      --restart \
      --print-events \
      ${lib.getExe build-and-copy}
  '';

  # https://crates.io/crates/live-server
  server = writeShellScriptBin "server" ''
    set -euxo pipefail

    ${lib.getExe live-server} \
      --host=127.0.0.1 \
      --open=${open} \
      $serve
  '';
in
writeShellScriptBin "devmode" ''
  set -euxo pipefail

  function handle_exit {
    rm -rf "$tmpdir"
  }

  tmpdir=$(mktemp -d)
  trap handle_exit EXIT

  export out_link="$tmpdir/result"
  export serve="$tmpdir/serve"
  mkdir $serve

  ${lib.getExe parallel} \
    --will-cite \
    --line-buffer \
    --tagstr '{/}' \
    ::: \
    "${lib.getExe watcher}" \
    "${lib.getExe server}"
''
