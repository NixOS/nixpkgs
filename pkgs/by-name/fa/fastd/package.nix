{ lib
, stdenv
, fetchFromGitHub
, bison
, meson
, ninja
, pkg-config
, libmnl
, libuecc
, libsodium
, libcap
, json_c
, openssl
}:

stdenv.mkDerivation rec {
  pname = "fastd";
  version = "22";

  src = fetchFromGitHub {
    owner  = "Neoraider";
    repo = "fastd";
    rev = "v${version}";
    sha256 = "0qni32j7d3za9f87m68wq8zgalvfxdrx1zxi6l4x7vvmpcw5nhpq";
  };

  nativeBuildInputs = [
    bison
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    json_c
    libcap
    libsodium
    libuecc
    openssl
  ] ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    libmnl
  ];

  # some options are only available on x86
  mesonFlags = lib.optionals (!stdenv.hostPlatform.isx86) [
    "-Dcipher_salsa20_xmm=disabled"
    "-Dcipher_salsa2012_xmm=disabled"
    "-Dmac_ghash_pclmulqdq=disabled"
  ];

  meta = with lib; {
    description = "Fast and Secure Tunneling Daemon";
    homepage = "https://projects.universe-factory.net/projects/fastd/wiki";
    license = with licenses; [ bsd2 bsd3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    mainProgram = "fastd";
  };
}
