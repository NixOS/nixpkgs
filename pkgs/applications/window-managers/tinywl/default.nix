{ lib, stdenv, wlroots, pkg-config, wayland-scanner
, libxkbcommon, pixman, udev, wayland, wayland-protocols
}:

stdenv.mkDerivation {
  pname = "tinywl";
  inherit (wlroots) version src patches postPatch;

  nativeBuildInputs = [ pkg-config wayland-scanner ];
  buildInputs = [ libxkbcommon pixman udev wayland wayland-protocols wlroots ];

  makeFlags = [ "-C" "tinywl" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp tinywl/tinywl $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://gitlab.freedesktop.org/wlroots/wlroots/tree/master/tinywl";
    description = ''A "minimum viable product" Wayland compositor based on wlroots'';
    maintainers = with lib.maintainers; [ qyliss ] ++ wlroots.meta.maintainers;
    license = lib.licenses.cc0;
    inherit (wlroots.meta) platforms;
    mainProgram = "tinywl";
  };
}
