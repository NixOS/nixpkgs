{ stdenv, gnvim-unwrapped, neovim, makeWrapper, wrapGAppsHook, librsvg, gdk_pixbuf }:

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
      --set GNVIM_RUNTIME_PATH "${gnvim-unwrapped}/share/gnvim/runtime" \
      ''${gappsWrapperArgs[@]}

    mkdir -p "$out/share"
    ln -s '${gnvim-unwrapped}/share/icons' "$out/share/icons"

    # copy and fix .desktop file
    cp -r '${gnvim-unwrapped}/share/applications' "$out/share/applications"
    # Sed needs a writable directory to do inplace modifications
    chmod u+rw "$out/share/applications"
    for file in $out/share/applications/*.desktop; do
      sed -e "s|Exec=.\\+gnvim\\>|Exec=$out/bin/gnvim|" -i "$file"
    done
  '';

  preferLocalBuild = true;

  # prevent double wrapping
  dontWrapGApps = true;
  # With strictDeps, wrapGAppsHook & co. do not pick up the dependencies correctly.
  strictDeps = false;
  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook
  ];

  passthru.unwrapped = gnvim-unwrapped;

  inherit (gnvim-unwrapped) meta;
}

