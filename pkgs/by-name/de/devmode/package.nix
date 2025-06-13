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
  build-and-link = writeShellApplication {
    name = "build-and-link";
    text = ''
      set -euxo pipefail

      out_link="$(nix-build --no-out-link ${buildArgs})"
      rm -rf "''${serve:?}"
      ln -sf "''${out_link:?}" "''${serve:?}"
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

    parallel \
      --will-cite \
      --line-buffer \
      --tagstr '{/}' \
      ::: \
      watcher \
      server
  '';
}
