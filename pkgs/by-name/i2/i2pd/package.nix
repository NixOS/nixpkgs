{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  cmake,
  ninja,
  boost,
  zlib,
  openssl,
  upnpSupport ? true,
  miniupnpc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "i2pd";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "PurpleI2P";
    repo = "i2pd";
    tag = finalAttrs.version;
    hash = "sha256-CoggAEUnGhnUudHxxGvOng4VApWZx744RYdrzG5ftFM=";
  };

  buildInputs = [
    boost
    zlib
    openssl
  ]
  ++ lib.optional upnpSupport miniupnpc;

  nativeBuildInputs = [
    installShellFiles
    cmake
    ninja
  ];

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
    (lib.cmakeBool "WITH_UPNP" upnpSupport)
  ];

  preConfigure = ''
    cd build
  '';

  preInstallPhase = ''
    install --mode=444 -D 'contrib/i2pd.service' "$out/etc/systemd/system/i2pd.service"
    installManPage 'debian/i2pd.1'
  '';

  meta = {
    homepage = "https://i2pd.website";
    description = "Minimal I2P router written in C++";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ edwtjo ];
    platforms = lib.platforms.unix;
    mainProgram = "i2pd";
  };
})
