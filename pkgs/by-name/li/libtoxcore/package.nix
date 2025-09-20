{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsodium,
  ncurses,
  libopus,
  libvpx,
  check,
  libconfig,
  pkg-config,
}:

let
  buildToxAV = !stdenv.hostPlatform.isAarch32;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libtoxcore";
  version = "0.2.21";

  src = fetchFromGitHub {
    owner = "TokTok";
    repo = "c-toxcore";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-0lWUKW09JvHa0QDX7v4n5B2ckQrKU9TDkjKegDLTIUw=";
  };

  cmakeFlags = [
    "-DDHT_BOOTSTRAP=ON"
    "-DBOOTSTRAP_DAEMON=ON"
  ]
  ++ lib.optional buildToxAV "-DMUST_BUILD_TOXAV=ON";

  buildInputs = [
    libsodium
    ncurses
    libconfig
  ]
  ++ lib.optionals buildToxAV [
    libopus
    libvpx
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  doCheck = true;
  nativeCheckInputs = [ check ];

  # We might be getting the wrong pkg-config file anyway:
  # https://github.com/TokTok/c-toxcore/issues/2334
  postInstall = ''
    substituteInPlace $out/lib/pkgconfig/toxcore.pc \
      --replace-fail '=''${prefix}/' '='
  '';

  meta = {
    description = "P2P FOSS instant messaging application aimed to replace Skype";
    homepage = "https://tox.chat";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      peterhoeg
    ];
    platforms = lib.platforms.all;
  };
})
