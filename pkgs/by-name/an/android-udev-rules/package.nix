{
  lib,
  stdenv,
  fetchFromGitHub,
  udevCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "android-udev-rules";
  version = "20250525";

  src = fetchFromGitHub {
    owner = "M0Rf30";
    repo = "android-udev-rules";
    rev = finalAttrs.version;
    hash = "sha256-4ODU9EoVYV+iSu6+M9ePed45QkOZgWkDUlFTlWJ8ttQ=";
  };

  installPhase = ''
    runHook preInstall
    install -D 51-android.rules $out/lib/udev/rules.d/51-android.rules
    runHook postInstall
  '';

  nativeBuildInputs = [
    udevCheckHook
  ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/M0Rf30/android-udev-rules";
    description = "Android udev rules list aimed to be the most comprehensive on the net";
    longDescription = ''
      Android udev rules list aimed to be the most comprehensive on the net.
      To use on NixOS, simply add this package to services.udev.packages:
      ```nix
      services.udev.packages = [ pkgs.android-udev-rules ];
      ```
    '';
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    teams = [ lib.teams.android ];
  };
})
