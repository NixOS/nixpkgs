{
  stdenv,
  lib,
  fetchFromGitea,
  godot3-headless,
  godot3-export-templates,
  godot3,
  makeWrapper,
  just,
  inkscape,
  imagemagick,
}:

stdenv.mkDerivation rec {
  pname = "find-billy";
  version = "0.37.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "Find-Billy";
    rev = "v${version}";
    hash = "sha256-z1GR5W67LJb5z+u/qeFZreMK4B6PjB18coecLCYFHy8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    godot3-headless
    makeWrapper
    just
    inkscape
    imagemagick
  ];

  postPatch = ''
    substituteInPlace export_presets.cfg --replace 'res://build/icons/usr/share/icons/hicolor' $out/share/icons/hicolor
    substituteInPlace project.godot --replace 'res://build/icons/usr/share/icons/hicolor' $out/share/icons/hicolor

    substituteInPlace justfile --replace '{{build_icons_dir}}/usr' $out
  '';

  buildPhase = ''
    runHook preBuild

    # Cannot create file `/homeless-shelter/.config/godot/projects/...`
    export HOME=$TMPDIR
    # Link the export-templates to the expected location. The `--export` option expects the templates in the home directory.
    mkdir -p $HOME/.local/share/godot
    ln -s ${godot3-export-templates}/share/godot/templates $HOME/.local/share/godot

    mkdir -p $out/share/find-billy
    godot3-headless --export-pack 'Linux/X11' $out/share/${pname}/${pname}.pck
    makeWrapper ${godot3}/bin/godot3 $out/bin/${pname} \
      --add-flags "--main-pack" \
      --add-flags "$out/share/${pname}/${pname}.pck"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    just build-icons
    install -D ${pname}.desktop -t $out/share/applications

    runHook postInstall
  '';

  meta = with lib; {
    description = "A 2 dimensional Pixel Art Jump & Run";
    homepage = "https://codeberg.org/annaaurora/Find-Billy";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.annaaurora ];
  };
}
