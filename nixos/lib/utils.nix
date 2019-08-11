pkgs: with pkgs.lib;

rec {

  # Check whenever fileSystem is needed for boot
  fsNeededForBoot = fs: fs.neededForBoot
                     || elem fs.mountPoint [ "/" "/nix" "/nix/store" "/var" "/var/log" "/var/lib" "/etc" ];

  # Check whenever `b` depends on `a` as a fileSystem
  fsBefore = a: b: a.mountPoint == b.device
                || hasPrefix "${a.mountPoint}${optionalString (!(hasSuffix "/" a.mountPoint)) "/"}" b.mountPoint;

  # Escape a path according to the systemd rules, e.g. /dev/xyzzy
  # becomes dev-xyzzy.  FIXME: slow.
  escapeSystemdPath = s:
   replaceChars ["/" "-" " "] ["-" "\\x2d" "\\x20"]
    (if hasPrefix "/" s then substring 1 (stringLength s) s else s);

  # Returns a system path for a given shell package
  toShellPath = shell:
    if types.shellPackage.check shell then
      "/run/current-system/sw${shell.shellPath}"
    else if types.package.check shell then
      throw "${shell} is not a shell package"
    else
      shell;
}
