{
  cargo,
  meson,
  ninja,
  oo7,
  oo7-server,
  pam,
  pkg-config,
  rustPlatform,
  rustc,
  stdenv,
  systemdLibs,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "oo7-pam";
  inherit (oo7) version src cargoDeps;

  sourceRoot = "${finalAttrs.src.name}/pam";
  cargoRoot = "../";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    rustPlatform.cargoSetupHook
    rustc
    cargo
  ];

  buildInputs = [
    pam
    systemdLibs
  ];

  # oo7-pam requires oo7-daemon-login, which is part of oo7-server
  mesonFlags = [
    "--libexecdir=${oo7-server}/libexec"
  ];

  meta = {
    inherit (oo7.meta)
      homepage
      changelog
      license
      maintainers
      platforms
      ;
    description = "${oo7.meta.description} (PAM modules)";
  };
})
