{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "roddhjav-apparmor-rules";
  version = "0-unstable-2025-05-03";

  src = fetchFromGitHub {
    owner = "roddhjav";
    repo = "apparmor.d";
    rev = "6d8eda6b8735626d5c2d25a810fb7600a4e3d60e";
    hash = "sha256-y0qdiijSZligYPpt5qbK36KAt+q6mHN03lOqq6HPSRA=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/etc/apparmor.d
    cp -r apparmor.d/* $out/etc/apparmor.d
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/roddhjav/apparmor.d";
    description = "Over 1500 AppArmor profiles aiming to confine most linux processes";
    longDescription = ''
      AppArmor.d is a set of over 1500 AppArmor profiles whose aim is to confine
      most Linux based applications and processes. Confines all system services, user services
      and most desktop environments. Currently supported DEs are GNOME, KDE and XFCE (partial).
      If your DE is not listed in https://github.com/roddhjav/apparmor.d
      Do not use this, else it may break your system.
    '';
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      johnrtitor
    ];
  };
}
