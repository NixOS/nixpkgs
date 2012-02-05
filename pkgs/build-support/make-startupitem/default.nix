# given a pakcage with a $name.desktop file, makes a copy
# as autostart item.

{stdenv, lib}:
{ name     # name of the desktop file (without .desktop)
, package  # package where the desktop file resides in
, after ? null
, condition ? null
, phase ? "2"
}:

# the builder requires that
#   $package/share/applications/$name.desktop
# exists as file.

stdenv.mkDerivation {
  name = "autostart-${name}";
  priority = 5;

  buildCommand = ''
    ensureDir $out/share/autostart
    target=${name}.desktop
    cp ${package}/share/applications/${name}.desktop $target
    chmod +rw $target
    echo "X-KDE-autostart-phase=${phase}" >> $target
    ${lib.optionalString (after != null) ''echo "${after}" >> $target''}
    ${lib.optionalString (condition != null) ''echo "${condition}" >> $target''}
    cp $target $out/share/autostart
  '';

  # this will automatically put 'package' in the environment when you
  # put its startup item in there.
  propagatedBuildInputs = [ package ];
}