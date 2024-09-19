{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  flex,
  bison,
  systemd,
  postgresql,
  openssl,
  libyaml,
  darwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fluent-bit";
  version = "3.1.8";

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-bit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SQltn4tbBGOFxascERG7J29vGz/jdq/4BWMH7P4BP64=";
  };

  # optional only to avoid linux rebuild
  patches = lib.optionals stdenv.isDarwin [ ./macos-11-sdk-compat.patch ];

  nativeBuildInputs = [
    cmake
    flex
    bison
  ];

  buildInputs =
    [
      openssl
      libyaml
      postgresql
    ]
    ++ lib.optionals stdenv.isLinux [ systemd ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk_11_0.frameworks.IOKit
      darwin.apple_sdk_11_0.frameworks.Foundation
    ];

  cmakeFlags = [
    "-DFLB_RELEASE=ON"
    "-DFLB_METRICS=ON"
    "-DFLB_HTTP_SERVER=ON"
    "-DFLB_OUT_PGSQL=ON"
  ] ++ lib.optionals stdenv.isDarwin [ "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.13" ];

  env.NIX_CFLAGS_COMPILE = toString (
    # Used by the embedded luajit, but is not predefined on older mac SDKs.
    lib.optionals stdenv.isDarwin [ "-DTARGET_OS_IPHONE=0" ]
    # Assumes GNU version of strerror_r, and the posix version has an
    # incompatible return type.
    ++ lib.optionals (!stdenv.hostPlatform.isGnu) [ "-Wno-int-conversion" ]
  );

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace /lib/systemd $out/lib/systemd
  '';

  meta = {
    changelog = "https://github.com/fluent/fluent-bit/releases/tag/v${finalAttrs.version}";
    description = "Log forwarder and processor, part of Fluentd ecosystem";
    homepage = "https://fluentbit.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      samrose
      fpletz
    ];
    platforms = lib.platforms.unix;
  };
})
