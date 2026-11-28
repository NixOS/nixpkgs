{
  fetchFromGitLab,
  lib,
  libgit2,
  openssl,
  pkg-config,
  replaceVars,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "calver";

  version = "1.1.12";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "op_so";
    repo = "calver";
    tag = "v${finalAttrs.version}";
    hash = "sha256:0qj2r7049kw990iaz2i4gkyzhcb04i3by1h0z2js9hpfzrv7kqbn";
  };

  postPatch = ''
    sed -i -e "s/0\.0\.0/${finalAttrs.version}/g" Cargo.toml
  '';

  cargoHash = "sha256-Vlidrwp8m/bmq4nPNUEQNl2Wh5Mh0sHFzFmucQmqdd4=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  doInstallCheck = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
  ];

  patches = [
    (replaceVars ./patches/calver-use-correct-binary-path-in-tests.patch {
      target_triple = stdenv.hostPlatform.rust.rustcTarget;
    })
  ];

  meta = {
    description = "A lightweight cli tool for effortless Calendar Versioning increments.";
    homepage = "https://gitlab.com/op_so/projects/calver";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      vpayno
    ];
    platforms = lib.platforms.all;
    mainProgram = "calver";
  };
})
