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
      rm -rf "''${serve:?}"
      mkdir -p "$(dirname "''${error_page_absolute:?}")"

      cat > "''${error_page_absolute:?}" << EOF
      <!DOCTYPE html>
      <html>
      <head>
        <style>
          @media (prefers-color-scheme: dark) {
            :root { filter: invert(100%); }
          }
        </style>
      </head>
      <body/><pre/>building...
      EOF
    '';
  };

  build-and-link = writeShellApplication {
    name = "build-and-link";
    runtimeInputs = [ error-page ];
    text = ''
      error-page

      set +e
      2>&1 nix-build --out-link "''${staging:?}" ${buildArgs} \
        | tee -a "''${error_page_absolute:?}"
      exit_status=$?
      set -e

      if [ $exit_status -eq 0 ]; then
        rm -rf "''${serve:?}"
        mv "''${staging:?}" "''${serve:?}"
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
      watchexec \
        --shell=none \
        --restart \
        build-and-link
    '';
  };

  # https://crates.io/crates/live-server
  server = writeShellApplication {
    name = "server";
    runtimeInputs = [ live-server ];
    text = ''
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
    function handle_exit {
      rm -rf "$tmpdir"
    }

    tmpdir="$(mktemp -d)"
    trap handle_exit EXIT

    export serve="$tmpdir/serve"
    export staging="$tmpdir/staging"
    export error_page_absolute="$serve/${open}"

    error-page

    parallel \
      --will-cite \
      --line-buffer \
      --tagstr '{/}' \
      ::: \
      watcher \
      server
  '';
}
