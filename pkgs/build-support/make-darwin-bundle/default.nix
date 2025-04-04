# given a package with an executable and an icon, make a darwin bundle for
# it. This package should be used when generating launchers for native Darwin
# applications. If the package contains a .desktop file use
# `desktopToDarwinBundle` instead.

{
  lib,
  writeShellScript,
  writeDarwinBundle,
}:

{
  name, # The name of the Application file.
  exec, # Executable file.
  icon ? "", # Optional icon file.
}:

writeShellScript "make-darwin-bundle-${name}" (''
  function makeDarwinBundlePhase() {
    mkdir -p "''${!outputBin}/Applications/${name}.app/Contents/MacOS"
    mkdir -p "''${!outputBin}/Applications/${name}.app/Contents/Resources"

    if [ -n "${icon}" ]; then
      ln -s "${icon}" "''${!outputBin}/Applications/${name}.app/Contents/Resources"
    fi

    ${writeDarwinBundle}/bin/write-darwin-bundle "''${!outputBin}" "${name}" "${exec}"
  }

  appendToVar preDistPhases makeDarwinBundlePhase
'')
