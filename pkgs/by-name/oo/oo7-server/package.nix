{
  lib,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      name = "resolve-aliases-in-set_locked.patch";
      url = "https://github.com/linux-credentials/oo7/pull/585.patch";
      hash = "sha256-L2ZoNUFOJpEnkU44buks7Dje/U7FAS8Jz1d4OHs1Ot8=";
    })
  ];

  patchFlags = [ "-p2" ];

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
