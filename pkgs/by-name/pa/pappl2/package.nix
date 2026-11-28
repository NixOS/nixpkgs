{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libcups3,
  avahi,
  zlib,
  libjpeg,
  libpng,
  libusb1,
  pam,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pappl";
  version = "2.0b1-unstable-2026-07-01";

  src = fetchFromGitHub {
    owner = "nick-linux8";
    repo = "pappl";
    rev = "72f5138a00b986d98c0335ad6965d0fa514e530a";
    hash = "sha256-Zks9RlNis6LW87XfsGnG/lCzErMtCmtbRrY+AOgKDqU=";
  };

  __structuredAttrs = true;

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libcups3
    avahi
    zlib
    libjpeg
    libpng
    libusb1
    openssl
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux pam;

  strictDeps = true;

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--with-papplstatedir=/var/lib"
    "--with-papplsockdir=/run"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isLinux) [ "--disable-libpam" ];

  postFixup = ''
    pc="$dev/lib/pkgconfig/pappl2.pc"
    if [ -f "$pc" ]; then
      # Requires: line exists but is empty — replace it in place
      sed -i 's/^Requires:[[:space:]]*$/Requires: cups3/' "$pc"
      echo "patched pappl2.pc:"
      cat "$pc"
    fi
  '';

  meta = {
    description = "PAPPL printer application framework, built as pappl2 against libcups3";
    homepage = "https://github.com/michaelrsweet/pappl";
    license = with lib.licenses; [
      asl20
    ];
    maintainers = with lib.maintainers; [
      nick-linux
    ];
    platforms = lib.platforms.unix;
  };
})
