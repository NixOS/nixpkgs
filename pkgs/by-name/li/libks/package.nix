{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  libuuid,
  openssl,
  libossp_uuid,
  freeswitch,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "libks";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "signalwire";
    repo = "libks";
    rev = "v${version}";
    sha256 = "sha256-fiBemt71UJgN0RryGmGiK7sob1xbdmSOArEGt5Pg5YM=";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/openwrt/telephony/5ced7ea4fc9bd746273d564bf3c102f253d2182e/libs/libks/patches/01-find-libm.patch";
      sha256 = "1hyrsdxg69d08qzvf3mbrx2363lw52jcybw8i3ynzqcl228gcg8a";
    })
  ];

  dontUseCmakeBuildDir = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libuuid
  ++ lib.optional stdenv.hostPlatform.isDarwin libossp_uuid;

  passthru = {
    tests.freeswitch = freeswitch;
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Foundational support for signalwire C products";
    homepage = "https://github.com/signalwire/libks";
    maintainers = with lib.maintainers; [ misuzu ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
