{
  lib,
  live-server,
  parallel,
  watchexec,
  writeShellScriptBin,
  # arguments to `nix-build`, e.g. `"foo.nix -A bar"`
  buildArgs ? "",
  # what path to open a browser at
  open ? "/index.html",
}:
let
  build-and-link = writeShellScriptBin "build-and-link" ''
    set -euxo pipefail

    out_link="$(nix-build --no-out-link ${buildArgs})"
    rm -rf $serve
    ln -sf $out_link $serve
  '';

  # https://watchexec.github.io/
  watcher = writeShellScriptBin "watcher" ''
    set -euxo pipefail

    ${lib.getExe watchexec} \
      --shell=none \
      --restart \
      --print-events \
      ${lib.getExe build-and-link}
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
