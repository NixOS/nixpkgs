{
  stdenv,
  lib,
  fetchFromGitea,
  godot_4,
  makeWrapper,
  just,
  inkscape,
  imagemagick,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "find-billy";
  version = "1.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "Find-Billy";
    rev = "v${version}";
    hash = "sha256-jKN3lEnLy0aN98S8BN3dcoOgc0RrxNoqfQdeCawKQaU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    godot_4
    makeWrapper
    just
    inkscape
    imagemagick
  ];

  postPatch = ''
    substituteInPlace export_presets.cfg --replace-fail 'res://build/icons/usr/share/icons/hicolor' $out/share/icons/hicolor
    substituteInPlace project.godot --replace-fail 'res://build/icons/usr/share/icons/hicolor' $out/share/icons/hicolor

    substituteInPlace justfile --replace-fail '{{build_icons_dir}}/usr' $out
  '';

  buildPhase = ''
    runHook preBuild

    # Cannot create file `/homeless-shelter/.config/godot/projects/...`
    export HOME=$TMPDIR
    # Link the export-templates to the expected location. The `--export` option expects the templates in the home directory.
    mkdir -p $HOME/.local/share/godot
    ln -s ${godot_4}/share/godot/templates $HOME/.local/share/godot

    mkdir -p $out/share/find-billy
    # the export preset here is for x86_64 but the pack format is architecture independant
    godot4 --headless --export-pack 'linux_x86-64' $out/share/find-billy/find-billy.pck
    makeWrapper ${godot_4}/bin/godot4 $out/bin/find-billy \
      --add-flags "--main-pack" \
      --add-flags "$out/share/find-billy/find-billy.pck"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    just build-icons
    install -D find-billy.desktop -t $out/share/applications

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "2 dimensional Pixel Art Jump & Run";
    homepage = "https://codeberg.org/annaaurora/Find-Billy";
    license = licenses.gpl3Plus;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = [ maintainers.annaaurora ];
  };
}
