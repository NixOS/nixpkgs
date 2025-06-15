{
  live-server,
  parallel,
  watchexec,
  writeShellApplication,
  # arguments to `nix-build`, e.g. `"foo.nix -A bar"`
  buildArgs ? "",
  # what path to open a browser at
  open ? "/index.html",
}:
let
  error-page = writeShellApplication {
    name = "error-page";
    text = ''
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
  };

  build-and-link = writeShellApplication {
    name = "build-and-link";
    runtimeInputs = [ error-page ];
    text = ''
      set -euxo pipefail

      set +e
      stderr=$(2>&1 nix-build --no-out-link ${buildArgs})
      exit_status=$?
      set -e

      rm -rf "''${serve:?}"

      if [ $exit_status -eq 0 ];
      then
        out_link="$(nix-build --no-out-link ${buildArgs})"
        ln -sf "$out_link" "''${serve:?}"
      else
        mkdir -p "$(dirname "''${error_page_absolute:?}")"

        error-page "$stderr" > "''${error_page_absolute:?}"
      fi
    '';
  };

  # https://watchexec.github.io/
  watcher = writeShellApplication {
    name = "watcher";
    runtimeInputs = [
      watchexec
      build-and-link
    ];
    text = ''
      set -euxo pipefail

      watchexec \
        --shell=none \
        --restart \
        --print-events \
        build-and-link
    '';
  };

  # https://crates.io/crates/live-server
  server = writeShellApplication {
    name = "server";
    runtimeInputs = [ live-server ];
    text = ''
      set -euxo pipefail

      live-server \
        --host=127.0.0.1 \
        --open=${open} \
        "''${serve:?}"
    '';
  };
in
writeShellApplication {
  name = "devmode";
  runtimeInputs = [
    parallel
    watcher
    server
    error-page
  ];
  text = ''
    set -euxo pipefail

    function handle_exit {
      rm -rf "$tmpdir"
    }

    tmpdir="$(mktemp -d)"
    trap handle_exit EXIT

    export serve="$tmpdir/serve"

    mkdir "$serve"
    export error_page_absolute="$serve/${open}"

    mkdir -p "$(dirname "''${error_page_absolute:?}")"
    error-page "building …" > "$error_page_absolute"

    parallel \
      --will-cite \
      --line-buffer \
      --tagstr '{/}' \
      ::: \
      watcher \
      server
  '';
}
