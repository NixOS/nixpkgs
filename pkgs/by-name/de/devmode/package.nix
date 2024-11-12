{
  lib,
  findutils,
  nodejs_latest,
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
  inherit (nodejs_latest.pkgs) live-server;

  error-page = writeShellScriptBin "error-page" ''
    cat << EOF
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
        $out_link/ \
        $serve/
    else
      set +x
      ${lib.getExe error-page} "$stderr" > $error_page_absolute
      set -x

      ${lib.getExe findutils} $serve \
        -type f \
        ! -name $error_page_relative \
        -delete
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

  # A Rust alternative to live-server exists, but it fails to open the temporary directory.
  # `--no-css-inject`: without this it seems that only CSS is auto-reloaded.
  # https://www.npmjs.com/package/live-server
  server = writeShellScriptBin "server" ''
    set -euxo pipefail

    ${lib.getExe' live-server "live-server"} \
      --host=127.0.0.1 \
      --verbose \
      --no-css-inject \
      --entry-file=$error_page_relative \
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
  export error_page_relative=error.html
  export error_page_absolute=$serve/$error_page_relative
  ${lib.getExe error-page} "building …" > $error_page_absolute

  ${lib.getExe parallel} \
    --will-cite \
    --line-buffer \
    --tagstr '{/}' \
    ::: \
    "${lib.getExe watcher}" \
    "${lib.getExe server}"
''
