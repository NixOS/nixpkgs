{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  openssl,
}:

stdenv.mkDerivation {
  pname = "libu2f-emu";
  version = "0-unstable-2020-09-04";

  src = fetchFromGitHub {
    owner = "Agnoctopus";
    repo = "libu2f-emu";
    rev = "d1c4b9c2e1c42e8931033912c8b609521f2a7756";
    hash = "sha256-kDAXA/v2nb/QAiJpGs0rTjm0t6CdbonTwHHoYhDQExE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  postPatch = ''
    # Upstream meson.build uses error() instead of warning() for missing
    # doxygen/dot, which fails the configure.
    substituteInPlace meson.build \
      --replace-fail "error('Skip doc:" "warning('Skip doc:" \
      --replace-fail "error('Skip dot in doc:" "warning('Skip dot in doc:"

    # Fix header guard typo: TRANSaCTION_H -> TRANSACTION_H
    substituteInPlace src/usb/transaction.h \
      --replace-fail "define TRANSaCTION_H" "define TRANSACTION_H"
  '';

  # Disable -Werror: upstream uses OpenSSL EC_KEY APIs deprecated since 3.0.
  mesonFlags = [ "--warnlevel=2" ];
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = {
    description = "Universal 2nd Factor (U2F) Emulation C Library";
    homepage = "https://github.com/Agnoctopus/libu2f-emu";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ philiptaron ];
    platforms = lib.platforms.linux;
  };
}
