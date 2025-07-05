{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  boost,
  libevent,
  cmake,
  db4,
  sqlite,
  libsystemtap,
  pkg-config,
  zeromq,
  zlib,
  darwin,
  withWallet ? true,
  enableTracing ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "namecoind";
  version = "29.0";

  src = fetchFromGitHub {
    owner = "namecoin";
    repo = "namecoin-core";
    tag = "nc${finalAttrs.version}";
    hash = "sha256-cdu1at3nM8RpCmYXd3jnF3V+gyzHxp30ZXy/Inr5Sno=";
  };

  nativeBuildInputs =
    [
      cmake
      pkg-config
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      darwin.autoSignDarwinBinariesHook
    ];

  buildInputs =
    [
      boost
      libevent
      db4
      zeromq
      zlib
    ]
    ++ lib.optionals enableTracing [ libsystemtap ]
    ++ lib.optionals withWallet [ sqlite ]
    # building with db48 (for legacy descriptor wallet support) is broken on Darwin
    ++ lib.optionals (withWallet && !stdenv.hostPlatform.isDarwin) [ db4 ];

  enableParallelBuilding = true;

  cmakeFlags =
    [
      (lib.cmakeBool "BUILD_BENCH" false)
      (lib.cmakeBool "WITH_ZMQ" true)
      # building with db48 (for legacy wallet support) is broken on Darwin
      (lib.cmakeBool "WITH_BDB" (withWallet && !stdenv.hostPlatform.isDarwin))
      (lib.cmakeBool "WITH_USDT" (stdenv.hostPlatform.isLinux))
    ]
    ++ lib.optionals (!finalAttrs.doCheck) [
      (lib.cmakeBool "BUILD_GUI_TESTS" false)
    ]
    ++ lib.optionals (!withWallet) [

      (lib.cmakeBool "ENABLE_WALLET" false)
    ];

  NIX_LDFLAGS = lib.optionals (
    stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isStatic
  ) "-levent_core";

  nativeCheckInputs = [ python3 ];

  doCheck = true;

  checkFlags = [ "LC_ALL=en_US.UTF-8" ];

  meta = with lib; {
    description = "Decentralized open source information registration and transfer system based on the Bitcoin cryptocurrency";
    homepage = "https://namecoin.org";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
})
