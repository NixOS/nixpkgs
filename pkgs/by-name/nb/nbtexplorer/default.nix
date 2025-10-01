{
  stdenv,
  fetchzip,
  mono,
  gtk2,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "nbtexplorer";
  version = "2.8.0";

  src = fetchzip {
    url = "https://github.com/jaquadro/NBTExplorer/releases/download/v${version}-win/NBTExplorer-${version}.zip";
    sha256 = "sha256-T0FLxuzgVHBz78rScPC81Ns2X1Mw/omzvYJVRQM24iU=";
    stripRoot = false;
  };

  nativeBuildInputs = [mono];
  buildInputs = [gtk2];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin

    cat > $out/bin/nbtexplorer <<EOF
    #!/usr/bin/env bash

    if [ -z "$GTK2_RC_FILES" ] && [ -f "$HOME/.gtkrc-2.0" ]; then
      export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
    fi

    export LD_LIBRARY_PATH="${gtk2}/lib:\$LD_LIBRARY_PATH"
    exec ${mono}/bin/mono "$out/bin/NBTExplorer.exe" "\$@"
    EOF

    chmod +x $out/bin/nbtexplorer
  '';

  meta = with lib; {
    description = "NBT editor for Minecraft game data";
    homepage = "https://github.com/jaquadro/NBTExplorer";
    license = licenses.mit;
    platforms = platforms.unix;
    # I won't call myself a maintainer since this didn't receive updates
    # in 8 Years but if it ever updates count me in as the maintainer
    maintainers = with maintainers; [];
  };
}
