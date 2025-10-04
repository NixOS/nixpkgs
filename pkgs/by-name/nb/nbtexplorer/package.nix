{
  stdenv,
  fetchFromGitHub,
  mono,
  gtk2,
  msbuild,
  iconv,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "nbtexplorer";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "jaquadro";
    repo = "NBTExplorer";
    rev = "v${version}-win";
    sha256 = "uOoELun0keFYN1N2/a1IkCP1AZQvfDLiUdrLxxrhE/A=";
    fetchSubmodules = true;
  };

  buildInputs = [gtk2];

  nativeBuildInputs = [mono msbuild];

  preBuild = ''
    # Convert vendor files to UTF-8 using iconv
    for f in NBTExplorer/Vendor/Be.Windows.Forms.HexBox/*.cs; do
      iconv -f WINDOWS-1252 -t UTF-8 "$f" > "$f.tmp" && mv "$f.tmp" "$f"
    done
  '';

  buildPhase = ''
    msbuild NBTExplorer/NBTExplorer.csproj \
      /p:Configuration=Release \
      /p:UseSharedCompilation=false \
      /p:CodePage=65001
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp NBTExplorer/bin/Release/NBTExplorer.exe $out/bin/

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
    maintainers = with maintainers; [Peritia-System];
  };
}
