{ makeSetupHook, yarn, nodejs, fixup_yarn_lock }:

(makeSetupHook {
  name = "yarn-setup-hook.sh";
  deps = [ yarn nodejs fixup_yarn_lock ];
} ./yarn-setup-hook.sh) // {
  defaultYarnFlags = [
    "--offline"
    "--frozen-lockfile"
    "--ignore-engines"
    "--ignore-scripts"
    "--no-progress"
    "--non-interactive"
  ];
}
