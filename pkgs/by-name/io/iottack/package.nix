{
  lib,
  aws-lc,
  dbus,
  fetchFromGitHub,
  glib,
  libsigrok,
  libsigrokdecode,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iottack";
  version = "0.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "inradii";
    repo = "iottack";
    tag = finalAttrs.version;
    hash = "sha256-TkkFvrDLqPIjX4FDnoHZwFiAUxHTaNDzVk1kJXqFNvc=";
  };

  cargoHash = "sha256-Z1ojN1de/f4xTIjAlYK1nlp5uL+hH7oPFY3emq13epc=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    aws-lc
    dbus
    glib
    libsigrok
    libsigrokdecode
  ];

  # libsigrok-sys build script searches for LD_LIBRARY_PATH instead of using pkg-config
  preBuild = ''
    export LD_LIBRARY_PATH=${
      lib.makeLibraryPath [
        libsigrok
        libsigrokdecode
      ]
    }
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Framework for testing common IoT protocols and IoT implementations";
    homepage = "https://github.com/inradii/iottack";
    changelog = "https://github.com/inradii/iottack/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "iottack";
    platforms = lib.platforms.linux;
  };
})
