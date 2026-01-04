{
  lib,
  runCommand,
  makeWrapper,
  calamares,
  calamares-nixos-extensions,
}:
runCommand "calamares-wrapped"
  {
    inherit (calamares) version meta;

    nativeBuildInputs = [ makeWrapper ];
  }
  ''
    mkdir -p $out/bin

    cd ${calamares}

    for i in *; do
      if [ "$i" == "bin" ]; then
        continue
      fi
      ln -s ${calamares}/$i $out/$i
    done

    makeWrapper ${lib.getExe calamares} $out/bin/calamares \
      --prefix XDG_DATA_DIRS : ${calamares-nixos-extensions}/share \
      --prefix XDG_CONFIG_DIRS : ${calamares-nixos-extensions}/etc \
      --add-flag --xdg-config
  ''
