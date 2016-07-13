config: pkgs: with pkgs.lib;

rec {

  # Escape a path according to the systemd rules, e.g. /dev/xyzzy
  # becomes dev-xyzzy.  FIXME: slow.
  escapeSystemdPath = s:
   replaceChars ["/" "-" " "] ["-" "\\x2d" "\\x20"]
    (if hasPrefix "/" s then substring 1 (stringLength s) s else s);

  # We must escape interfaces due to the systemd interpretation
  subsystemDevice = interface:
   optionalString (!config.boot.isContainer)
    "sys-subsystem-net-devices-${escapeSystemdPath interface}.device";

  # Returns a system path for a given shell package
  toShellPath = shell:
    if types.shellPackage.check shell then
      "/run/current-system/sw${shell.shellPath}"
    else if types.package.check shell then
      throw "${shell} is not a shell package"
    else
      shell;
}
