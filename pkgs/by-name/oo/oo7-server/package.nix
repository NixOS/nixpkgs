{
  lib,
  cargo,
  meson,
  ninja,
  oo7,
  pkg-config,
  rustPlatform,
  rustc,
  stdenv,
  systemdLibs,
  useWrappedDaemon ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "oo7-server";
  inherit (oo7) version src cargoDeps;

  sourceRoot = "${finalAttrs.src.name}/server";
  cargoRoot = "../";

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    rustPlatform.cargoSetupHook
    rustc
    cargo
  ];

  buildInputs = [
    systemdLibs
  ];

  postFixup = lib.optionalString useWrappedDaemon ''
    substituteInPlace "$out/share/systemd/user/oo7-daemon.service" \
      --replace-fail "$out/libexec/oo7-daemon" "/run/wrappers/bin/oo7-daemon"
  '';

  meta = {
    inherit (oo7.meta)
      homepage
      changelog
      license
      maintainers
      platforms
      ;
    description = "${oo7.meta.description} (Daemon)";
  };
})
