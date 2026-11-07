{
  lib,
  mkDerivation,
  nvidia-driver,
  nvidia-libs,
  autoPatchelfHook,
}:
mkDerivation {
  path = "...";
  pname = "nvidia-x11";
  inherit (nvidia-driver) src version;

  extraNativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    nvidia-libs
  ];

  env.LOCALBASE = "${builtins.placeholder "out"}";

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    make -C x11 install
  '';

  meta.platforms = [ "x86_64-freebsd" ];
  meta.license = lib.licenses.unfree;
}
