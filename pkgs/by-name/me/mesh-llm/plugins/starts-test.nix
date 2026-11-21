# Starts mesh-llm offline with every plugin of mesh-llmPlugins, configured as
# services.mesh-llm.plugins does, and waits until the host reports each running.
{
  lib,
  runCommand,
  formats,
  curl,
  jq,
  mesh-llm,
  mesh-llmPlugins,
}:

let
  plugins = lib.filter lib.isDerivation (lib.attrValues mesh-llmPlugins);
  names = map (p: p.pluginName) plugins;
  # Darwin builds share the network. Ports from mesh-llm and the plugins keep
  # any other version of this test off this one's ports.
  inputs = builtins.unsafeDiscardStringContext (toString ([ mesh-llm ] ++ plugins));
  offset = lib.mod (lib.fromHexString (
    builtins.substring 0 4 (builtins.hashString "sha256" inputs)
  )) 1000;
  port = base: toString (base + offset);
  config = (formats.toml { }).generate "mesh-llm-config.toml" {
    version = 1;
    plugin = map (
      p:
      {
        name = p.pluginName;
        command = lib.getExe p;
      }
      # What a plugin needs to start at all, such as the URL of its server.
      // p.testSettings or { }
    ) plugins;
  };
in
runCommand "mesh-llm-plugins-start"
  {
    nativeBuildInputs = [
      mesh-llm
      curl
      jq
    ];
    # The node binds its API, console and mesh ports on localhost.
    __darwinAllowLocalNetworking = true;
    # On Darwin, iroh's interface detection reads ICU data from the system, as for mesh-llm.
    sandboxProfile = ''
      (allow file-read* (subpath "/usr/share/icu"))
    '';
  }
  ''
    export HOME=$TMPDIR/home XDG_CACHE_HOME=$TMPDIR/cache XDG_CONFIG_HOME=$TMPDIR/config
    export XDG_STATE_HOME=$TMPDIR/state MESH_LLM_NATIVE_RUNTIME_CACHE_DIR=$TMPDIR/runtimes
    export MESH_LLM_NO_RUNTIME_DOWNLOAD=1
    install -D -m 0600 ${config} $HOME/.mesh-llm/config.toml
    mesh-llm serve --headless --log-format json \
      --port ${port 21000} --console ${port 23000} --bind-port ${port 25000} > serve.jsonl 2>&1 &
    pid=$!
    trap '[ -e $out ] || cat serve.jsonl' EXIT
    running() {
      curl -fsS http://127.0.0.1:${port 23000}/api/plugins \
        | jq -e --arg n "$1" 'map(select(.name == $n))[0].status == "running"' > /dev/null
    }
    for name in ${lib.escapeShellArgs names}; do
      for _ in $(seq 240); do
        running "$name" && break
        kill -0 $pid || { echo "mesh-llm exited before $name was running" >&2; exit 1; }
        sleep 0.5
      done
      running "$name" || { echo "$name not running within 2 minutes" >&2; exit 1; }
      echo "$name is running"
    done
    # A plugin that crashed while the later ones started counts too.
    for name in ${lib.escapeShellArgs names}; do
      running "$name" || { echo "$name stopped running" >&2; exit 1; }
    done
    kill -INT $pid
    timeout 30 tail --pid=$pid -f /dev/null || { echo "mesh-llm did not stop after SIGINT" >&2; exit 1; }
    touch $out
  ''
