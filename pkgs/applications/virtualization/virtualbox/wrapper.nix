{ stdenv, symlinkJoin, makeWrapper, virtualbox, virtualboxExtpack }:

symlinkJoin {
  name = "virtualbox-wrapped-${virtualbox.version}";

  paths = [ virtualbox ];
  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''\
    for file in $(find $out/bin/*); do
      # skip non-executables
      patchelf --print-interpreter "$file" >/dev/null 2>&1 || continue
      wrapProgram $file --set VBOX_EXTPACK_DIR ${virtualboxExtpack}
    done
  '';

  inherit (virtualbox) meta version;
}
