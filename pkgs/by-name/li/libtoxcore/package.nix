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
    hash = "sha256-0lWUKW09JvHa0QDX7v4n5B2ckQrKU9TDkjKegDLTIUw=";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    (lib.cmakeBool "DHT_BOOTSTRAP" true)
    (lib.cmakeBool "BOOTSTRAP_DAEMON" true)
  ]
  ++ lib.optional buildToxAV (lib.cmakeBool "MUST_BUILD_TOXAV" true);

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

  postInstall = ''
    substituteInPlace $out/lib/pkgconfig/toxcore.pc \
      --replace '=''${prefix}/' '=' \

  '';
  # We might be getting the wrong pkg-config file anyway:
  # https://github.com/TokTok/c-toxcore/issues/2334

  meta = {
    description = "P2P FOSS instant messaging application aimed to replace Skype";
    homepage = "https://tox.chat";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      peterhoeg
      zatm8
    ];
    platforms = lib.platforms.all;
  };
})
