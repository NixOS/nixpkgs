{
  fetchgit,
  fetchpatch,
  lib,
  libftdi1,
  libgpiod,
  libjaylink,
  libusb1,
  meson,
  ninja,
  pciutils,
  pkg-config,
  stdenv,
  withJlink ? true,
  withGpio ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flashprog";
  version = "1.3";

  src = fetchgit {
    url = "https://review.sourcearcade.org/flashprog";
    rev = "648dfdc9272f02aaca0217fcdab542a10f45476e";
    hash = "sha256-ORbi5AapwY7Jf9gnHZe/6EWt+nzgBX5ejLRUmbPV3ME=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs =
    [
      libftdi1
      libusb1
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      pciutils
    ]
    ++ lib.optionals (withJlink) [
      libjaylink
    ]
    ++ lib.optionals (withGpio) [
      libgpiod
    ];

  postInstall = ''
    cd "$src"
    install -Dm644 util/50-flashprog.rules "$out/lib/udev/rules.d/50-flashprog.rules"
  '';

  meta = with lib; {
    homepage = "https://flashprog.org";
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [
      felixsinger
      funkeleinhorn
    ];
    platforms = platforms.all;
    mainProgram = "flashprog";
  };
})
