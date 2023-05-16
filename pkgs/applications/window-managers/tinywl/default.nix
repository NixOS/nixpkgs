{ lib, stdenv, wlroots, pkg-config, wayland-scanner
, libxkbcommon, pixman, udev, wayland, wayland-protocols
}:

stdenv.mkDerivation {
  pname = "tinywl";
  inherit (wlroots) version src;

<<<<<<< HEAD
  sourceRoot = "${wlroots.src.name}/tinywl";
=======
  sourceRoot = "source/tinywl";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config wayland-scanner ];
  buildInputs = [ libxkbcommon pixman udev wayland wayland-protocols wlroots ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp tinywl $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/swaywm/wlroots/tree/master/tinywl";
    description = ''A "minimum viable product" Wayland compositor based on wlroots'';
    maintainers = with maintainers; [ qyliss ] ++ wlroots.meta.maintainers;
    license = licenses.cc0;
    inherit (wlroots.meta) platforms;
  };
}
