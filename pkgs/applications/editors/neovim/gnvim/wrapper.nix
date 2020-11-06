{ stdenv, gnvim-unwrapped, neovim, makeWrapper }:

stdenv.mkDerivation {
  pname = "gnvim";
  version = gnvim-unwrapped.version;
  buildCommand = if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    cp -r ${gnvim-unwrapped}/bin/gnvim.app $out/Applications

    chmod -R a+w "$out/Applications/gnvim.app/Contents/MacOS"
    wrapProgram "$out/Applications/gnvim.app/Contents/MacOS/gnvim" \
      --prefix PATH : "${neovim}/bin" \
      --set GNVIM_RUNTIME_PATH "${gnvim-unwrapped}/share/gnvim/runtime"
  '' else ''
    makeWrapper '${gnvim-unwrapped}/bin/gnvim' "$out/bin/gnvim" \
      --prefix PATH : "${neovim}/bin" \
      --set GNVIM_RUNTIME_PATH "${gnvim-unwrapped}/share/gnvim/runtime"

    mkdir -p "$out/share"
    ln -s '${gnvim-unwrapped}/share/icons' "$out/share/icons"

    # copy and fix .desktop file
    cp -r '${gnvim-unwrapped}/share/applications' "$out/share/applications"
    # Sed needs a writable directory to do inplace modifications
    chmod u+rw "$out/share/applications"
    sed -e "s|Exec=.\\+gnvim\\>|Exec=gnvim|" -i $out/share/applications/*.desktop
  '';

  preferLocalBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  passthru.unwrapped = gnvim-unwrapped;

  inherit (gnvim-unwrapped) meta;
}

