{
  lib,
  stdenv,
  fetchFromGitHub,
  godot3-headless,
  godot3-export-templates,
  libglvnd,
  libX11,
  libXcursor,
  libXext,
  libXfixes,
  libXi,
  libXinerama,
  libXrandr,
  libXrender,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "material-maker";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "RodZill4";
    repo = "material-maker";
    rev = finalAttrs.version;
    hash = "sha256-vyagu7xL4ITt+xyoYyCcF8qq6L9sR6Ltdl6NwfrbZdA=";
  };

  nativeBuildInputs = [ godot3-headless ];

  buildInputs = [
    libglvnd

    libXinerama
    libXcursor
    libXext
    libXrandr
    libXrender
    libX11
    libXi
    libXfixes
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR

    # Link the export-templates to the expected location. The --export commands
    # expects the template-file at .../templates/{godot-version}.stable/linux_x11_64_release
    mkdir -p $HOME/.local/share/godot
    ln -s ${godot3-export-templates}/share/godot/templates $HOME/.local/share/godot

    # Don't use the included export template, which might use a mismatched version of godot.
    rm ./material_maker/misc/linux/godot.x11.opt.64
    substituteInPlace ./export_presets.cfg \
      --replace-fail '"material_maker/misc/linux/godot.x11.opt.64"' '""'

    mkdir -vp build
    godot3-headless -v --export 'Linux/X11' build/material-maker

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -vp $out/share/material-maker
    cp -vr \
      ./build/* \
      ./addons/material_maker/nodes  \
      ./material_maker/environments  \
      ./material_maker/examples  \
      ./material_maker/library  \
      ./material_maker/meshes  \
      ./material_maker/misc/export \
      $out/share/material-maker

    mkdir -vp $out/bin
    ln -vs $out/share/material-maker/material-maker $out/bin/material-maker

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    patchelf \
      --set-interpreter '${stdenv.cc.bintools.dynamicLinker}' \
      --set-rpath ${lib.makeLibraryPath finalAttrs.buildInputs} \
      $out/share/material-maker/material-maker

    runHook postFixup
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Procedural materials authoring tool";
    mainProgram = "material-maker";
    homepage = "https://www.materialmaker.org";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ lelgenio ];
  };
})
