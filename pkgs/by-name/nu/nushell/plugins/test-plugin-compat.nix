{
  lib,
  stdenv,
  runCommand,
  nushell,
  nushellPlugins,
}:
let
  # Nushell refuses to load a plugin that was not compiled against its own
  # major/minor version, and nothing about building a plugin catches that: a
  # stale plugin builds fine and only fails when nu tries to load it. So a
  # nushell bump silently breaks every plugin not updated in lockstep. Load all
  # of them here so that shows up in the build instead of on a user's machine.
  # tryEval steps over the removal aliases, which throw when forced.
  plugins = lib.filter (
    p: lib.isDerivation p && lib.meta.availableOn stdenv.hostPlatform p && !(p.meta.broken or false)
  ) (lib.filter (p: (builtins.tryEval p).success) (lib.attrValues nushellPlugins));

  nuWithPlugins = nushell.withPlugins plugins;

  # `plugin list` reports plugins by their registered name, which is the
  # mainProgram without the `nu_plugin_` prefix.
  expected = lib.sort (a: b: a < b) (
    lib.map (p: lib.removePrefix "nu_plugin_" (baseNameOf (lib.getExe p))) plugins
  );
in
runCommand "nushell-plugin-compat-test" { } ''
  expected=${lib.escapeShellArg (lib.concatStringsSep "\n" expected)}

  # nu exits non-zero when a plugin fails to load; keep going so the
  # comparison below can report which one it was.
  actual=$(env -u XDG_DATA_DIRS HOME=/homeless-shelter \
    ${nuWithPlugins}/bin/nu --no-config-file -c 'plugin list | get name | sort | to text' 2>&1 || true)

  if [ "$actual" != "$expected" ]; then
    echo "FAIL: the set of loadable plugins does not match the set of non-broken plugins."
    echo "A plugin that fails to load is compiled for a different nushell version;"
    echo "either update it, or mark it broken in its package.nix."
    echo "--- expected ---"
    echo "$expected"
    echo "--- actual ---"
    echo "$actual"
    exit 1
  fi

  touch $out
''
