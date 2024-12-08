{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
  pkg-config,
  libuuid,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "optee-client";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "OP-TEE";
    repo = "optee_client";
    rev = finalAttrs.version;
    hash = "sha256-VW41O8c5cyE5tq950/1z/f9HfrZyh4Aepk7G6MEGTj4=";
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  nativeBuildInputs = [
    which
    pkg-config
  ];
  buildInputs = [ libuuid ];

  makeFlags =
    [
      "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
      "DESTDIR=$(out)"
      "SBINDIR=/bin"
      "INCLUDEDIR=/include"
      "LIBDIR=/lib"
    ]
    ++
    # If we are not a static build, change default optee config to use paths that
    # will work well with NixOS.
    lib.optionals (!stdenv.hostPlatform.isStatic) [
      "CFG_TEE_CLIENT_LOAD_PATH=/run/current-system/sw/lib"
      "CFG_TEE_PLUGIN_LOAD_PATH=/run/current-system/sw/lib/tee-supplicant/plugins"
      "CFG_TEE_FS_PARENT_PATH=/var/lib/tee"
    ];

  preFixup = ''
    mkdir -p $lib $dev
    mv $out/lib $lib
    mv $out/include $dev
  '';

  meta = {
    description = "Normal world client for OPTEE OS";
    homepage = "https://github.com/OP-TEE/optee_client";
    changelog = "https://github.com/OP-TEE/optee_client/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.jmbaur ];
    platforms = [
      "aarch64-linux"
      "armv7l-linux"
    ];
  };
})
