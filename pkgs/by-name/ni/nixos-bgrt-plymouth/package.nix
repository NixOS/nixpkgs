{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  name = "nixos-bgrt-plymouth";
  version = "0-unstable-2024-10-25";

  src = fetchFromGitHub {
    repo = "plymouth-theme-nixos-bgrt";
    owner = "helsinki-systems";
    rev = "9b3913c38212463f3e21e8e805eead8f332215fa";
    hash = "sha256-VmNATLInItV2uMYJgpo8ywBUtfiqgcspPkRL9ws5zag=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plymouth/themes/nixos-bgrt
    cp -r $src/{*.plymouth,images} $out/share/plymouth/themes/nixos-bgrt/
    substituteInPlace $out/share/plymouth/themes/nixos-bgrt/*.plymouth --replace '@IMAGES@' "$out/share/plymouth/themes/nixos-bgrt/images"

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "BGRT theme with a spinning NixOS logo";
    homepage = "https://github.com/helsinki-systems/plymouth-theme-nixos-bgrt";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
