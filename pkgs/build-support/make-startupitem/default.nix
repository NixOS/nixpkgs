# given a package with a $name.desktop file, makes a copy
# as autostart item.

{stdenv, lib}:
{ name            # name of the desktop file (without .desktop)
, package         # package where the desktop file resides in
, srcPrefix ? ""  # additional prefix that the desktop file may have in the 'package'
, after ? null
, condition ? null
, phase ? "2"
, prependExtraArgs ? []
, appendExtraArgs ? []
}:

# the builder requires that
#   $package/share/applications/$name.desktop
# exists as file.

stdenv.mkDerivation {
  name = "autostart-${name}";
  priority = 5;

  buildCommand = let
    escapeArgs = args: lib.escapeRegex (lib.escapeShellArgs args);
    prependArgs = lib.optionalString (prependExtraArgs != []) "${escapeArgs prependExtraArgs} ";
    appendArgs = lib.optionalString (appendExtraArgs != []) " ${escapeArgs appendExtraArgs}";
  in ''
    mkdir -p $out/etc/xdg/autostart
    target=${name}.desktop
    cp ${package}/share/applications/${srcPrefix}${name}.desktop $target
    ${lib.optionalString (prependExtraArgs != [] || appendExtraArgs != []) ''
      sed -i -r "s/(Exec=)([^ ]*) (.*)/\1\2 ${prependArgs}\3${appendArgs}/" $target
    ''}
    chmod +rw $target
    echo "X-KDE-autostart-phase=${phase}" >> $target
    ${lib.optionalString (after != null) ''echo "${after}" >> $target''}
    ${lib.optionalString (condition != null) ''echo "${condition}" >> $target''}
    cp $target $out/etc/xdg/autostart
  '';

  # this will automatically put 'package' in the environment when you
  # put its startup item in there.
  propagatedBuildInputs = [ package ];
}
