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
  error-page = writeShellScriptBin "error-page" ''
    rm -rf $serve
    mkdir -p "$(dirname $error_page_absolute)"

    cat > $error_page_absolute << EOF
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        @media (prefers-color-scheme: dark) {
          :root { filter: invert(100%); }
        }
      </style>
    </head>
    <body><pre>$1</pre></body>
    </html>
    EOF
  '';

  build-and-link = writeShellScriptBin "build-and-link" ''
    set -euxo pipefail

    set +e
    stderr=$(2>&1 nix-build --out-link $staging ${buildArgs})
    exit_status=$?
    set -e

    rm -rf $serve

    if [ $exit_status -eq 0 ]; then
      mv $staging $serve
    else
      ${lib.getExe error-page} "$stderr"
    fi
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
  export staging="$tmpdir/staging"
  export error_page_absolute="$serve/${open}"

  ${lib.getExe error-page} "building …"

  ${lib.getExe parallel} \
    --will-cite \
    --line-buffer \
    --tagstr '{/}' \
    ::: \
    "${lib.getExe watcher}" \
    "${lib.getExe server}"
''
