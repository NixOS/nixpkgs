{
  lib,
  stdenv,
  ddcutil,
  fetchFromGitHub,
  gtk4,
  installShellFiles,
  libadwaita,
  nix-update-script,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "luminance";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "sidevesh";
    repo = "Luminance";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-1xDRs+OBzcrB75pILA3ZxIrZEleWVBROBNZz0MsCWnA=";
  };

  # Use our own ddcbc-api source
  #
  # Patch build.sh with the stdenv agnostic `$CC` variable
  postPatch = ''
    rmdir ddcbc-api
    ln -sf ${finalAttrs.passthru.ddcbc-api} ddcbc-api

    patchShebangs build.sh
    substituteInPlace build.sh \
      --replace-fail 'gcc' '"$CC"'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    ddcutil
    gtk4
    libadwaita
  ];

  postBuild = "./build.sh";

  postInstall = ''
    mv build/app com.sidevesh.Luminance
    installBin com.sidevesh.Luminance

    install -Dm644 install_files/44-backlight-permissions.rules -t $out/lib/udev/rules.d
    install -Dm644 install_files/com.sidevesh.Luminance.desktop -t $out/share/applications
    install -Dm644 install_files/com.sidevesh.Luminance.gschema.xml -t $out/share/glib-2.0/schemas

    mv icons $out/share/icons
    rm $out/share/icons/com.sidevesh.luminance.Source.svg
  '';

  passthru = {
    ddcbc-api = fetchFromGitHub {
      owner = "ahshabbir";
      repo = "ddcbc-api";
      rev = "f54500284fcfc2f140d5ae01df779f3f47c9b563";
      hash = "sha256-ViKik3468AHjE7NxdfrKicDNA0ENG6DmIplYtKVqduw=";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple GTK application to control brightness of displays including external displays supporting DDC/CI";
    homepage = "https://github.com/sidevesh/Luminance";
    changelog = "https://github.com/sidevesh/Luminance/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    inherit (ddcutil.meta) platforms;
    mainProgram = "com.sidevesh.Luminance";
  };
})
