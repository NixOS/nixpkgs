# | Build a script to install and start a set of systemd units on any
# systemd-based system.
#
# Creates a symlink at /etc/systemd-static/${namespace} for slightly
# improved atomicity.
{
  writeScriptBin,
  bash,
  coreutils,
  systemd,
  runCommand,
  lib,
}:
{
  units,
  # : AttrSet String (Either Path { path : Path, wanted-by : [ String ] })
  # ^ A set whose names are unit names and values are
  # either paths to the corresponding unit files or a set
  # containing the path and the list of units this unit
  # should be wanted-by (none by default).
  #
  # The names should include the unit suffix
  # (e.g. ".service")
  namespace,
# : String
# The namespace for the unit files, to allow for
# multiple independent unit sets managed by
# `setupSystemdUnits`.
}:
let
  static = runCommand "systemd-static" { } ''
    mkdir -p $out
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (nm: file: "ln -sv ${file.path or file} $out/${nm}") units
    )}
  '';
  add-unit-snippet = name: file: ''
    oldUnit=$(readlink -f "$unitDir/${name}" || echo "$unitDir/${name}")
    if [ -f "$oldUnit" -a "$oldUnit" != "${file.path or file}" ]; then
      unitsToStop+=("${name}")
    fi
    ln -sf "/etc/systemd-static/${namespace}/${name}" \
      "$unitDir/.${name}.tmp"
    mv -T "$unitDir/.${name}.tmp" "$unitDir/${name}"
    ${lib.concatStringsSep "\n" (
      map (unit: ''
        mkdir -p "$unitDir/${unit}.wants"
        ln -sf "../${name}" \
          "$unitDir/${unit}.wants/.${name}.tmp"
        mv -T "$unitDir/${unit}.wants/.${name}.tmp" \
          "$unitDir/${unit}.wants/${name}"
      '') file.wanted-by or [ ]
    )}
    unitsToStart+=("${name}")
  '';
in
writeScriptBin "setup-systemd-units" ''
  #!${bash}/bin/bash -e
  export PATH=${coreutils}/bin:${systemd}/bin

  unitDir=/etc/systemd/system
  if [ ! -w "$unitDir" ]; then
    unitDir=/nix/var/nix/profiles/default/lib/systemd/system
    mkdir -p "$unitDir"
  fi
  declare -a unitsToStop unitsToStart

  oldStatic=$(readlink -f /etc/systemd-static/${namespace} || true)
  if [ "$oldStatic" != "${static}" ]; then
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList add-unit-snippet units)}
    if [ ''${#unitsToStop[@]} -ne 0 ]; then
      echo "Stopping unit(s) ''${unitsToStop[@]}" >&2
      systemctl stop "''${unitsToStop[@]}"
    fi
    mkdir -p /etc/systemd-static
    ln -sfT ${static} /etc/systemd-static/.${namespace}.tmp
    mv -T /etc/systemd-static/.${namespace}.tmp /etc/systemd-static/${namespace}
    systemctl daemon-reload
    echo "Starting unit(s) ''${unitsToStart[@]}" >&2
    systemctl start "''${unitsToStart[@]}"
  else
    echo "Units unchanged, doing nothing" >&2
  fi
''
