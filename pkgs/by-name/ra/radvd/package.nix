{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libbsd,
  libdaemon,
  bison,
  flex,
  check,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "radvd";
  version = "2.20_rc1";

  src = fetchFromGitHub {
    owner = "radvd-project";
    repo = "radvd";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-+cZn4pE4hBZDckfcQJzYdZxHkexWl/AmufCN5BiwWwA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    bison
    flex
    check
  ];

  buildInputs = [
    libdaemon
    libbsd
  ];

  # Needed for cross-compilation
  makeFlags = [ "AR=${stdenv.cc.targetPrefix}ar" ];

  passthru.tests = {
    inherit (nixosTests) connman ipv6 systemd-networkd-ipv6-prefix-delegation;
    privacy_scripted = nixosTests.networking.scripted.privacy;
    privacy_networkd = nixosTests.networking.networkd.privacy;
  };

  meta = with lib; {
    homepage = "http://www.litech.org/radvd/";
    changelog = "https://github.com/radvd-project/radvd/blob/${finalAttrs.src.rev}/CHANGES";
    description = "IPv6 Router Advertisement Daemon";
    downloadPage = "https://github.com/radvd-project/radvd";
    platforms = platforms.linux;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ fpletz ];
  };
})
