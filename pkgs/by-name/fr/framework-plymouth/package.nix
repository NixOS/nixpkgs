{
  stdenvNoCC,
  fetchFromSourcehut,
  lib,
  imagemagick,
}:

stdenvNoCC.mkDerivation {
  pname = "framework-plymouth";
  version = "0-unstable-2021-12-20";

  src = fetchFromSourcehut {
    owner = "~jameskupke";
    repo = "framework-plymouth-theme";
    rev = "b801f5bbf41df1cd3d1edeeda31d476ebf142f67";
    hash = "sha256-TuD+qHQ6+csK33oCYKfWRtpqH6AmYqvZkli0PtFm8+8=";
  };

  sourceRoot = "source/framework";
  nativeBuildInputs = [
    imagemagick
  ];

  buildPhase = ''
    runHook preBuild
    for image in throbber*.png; do
      [[ -e "$image" ]] || break
      magick "$image" -resize 25% "$image";
    done

    sed -i '{
      8s/3/2/     # decrease title font size from 30 to 20
      11s/382/8/  # move dialog to .8 of screen
      13s/382/3/  # move title to .3 of screen
      15s/5/8/    # move logo to .8 of screen
      28s/^/UseFirmwareBackground=true\n/  # display uefi logo @ boot
      31s/^/UseFirmwareBackground=true\n/  # display uefi logo @ shutdown
      34s/^/UseFirmwareBackground=true\n/  # display uefi logo @ reboot
    }' framework.plymouth
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"/share/plymouth/themes/framework
    cp * "$out"/share/plymouth/themes/framework
    sed -i "s@/usr/@$out/@" "$out"/share/plymouth/themes/framework/framework.plymouth
    runHook postInstall
  '';

  meta = {
    description = "Plymouth boot theme with animated Framework logo";
    longDescription = ''
      Framework's gear icon spins near the bottom of the screen, while also
      enabling their UEFI firmware logo to be displayed in the middle.
    '';
    homepage = "https://git.sr.ht/~jameskupke/framework-plymouth-theme";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ j-pap ];
    platforms = lib.platforms.linux;
  };
}
