{
  stdenv,
  bubblewrap,
  mktemp,
  writeShellScript,
  bitwig-studio-unwrapped,
}:
stdenv.mkDerivation {
  inherit (bitwig-studio-unwrapped) version;

  pname = "bitwig-studio";

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  installPhase =
    let
      wrapper = writeShellScript "bitwig-studio" ''
        set -e

        echo "Creating temporary directory"
        TMPDIR=$(${mktemp}/bin/mktemp --directory)
        echo "Temporary directory: $TMPDIR"
        echo "Copying default Vamp Plugin settings"
        cp -r ${bitwig-studio-unwrapped}/libexec/resources/VampTransforms $TMPDIR
        echo "Changing permissions to be writable"
        chmod -R u+w $TMPDIR/VampTransforms

        echo "Starting Bitwig Studio in Bubblewrap Environment"
        ${bubblewrap}/bin/bwrap \
          --bind / / \
          --bind $TMPDIR/VampTransforms ${bitwig-studio-unwrapped}/libexec/resources/VampTransforms \
          --dev-bind /dev /dev \
          ${bitwig-studio-unwrapped}/bin/bitwig-studio \
          || true

        echo "Bitwig exited, removing temporary directory"
        rm -rf $TMPDIR
      '';
    in
    ''
      mkdir -p $out/bin
      cp ${wrapper} $out/bin/bitwig-studio
      cp -r ${bitwig-studio-unwrapped}/share $out
    '';
}
