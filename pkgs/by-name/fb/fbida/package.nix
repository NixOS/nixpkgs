{
  lib,
  stdenv,
  fetchFromGitLab,
  hexdump,
  meson,
  ninja,
  perl,
  pkg-config,
  giflib,
  libdrm,
  libexif,
  libiconvReal,
  libinput,
  libtsm,
  libwebp,
  libxkbcommon,
  libxpm,
  libxt,
  motif,
  pixman,
  poppler,
  udev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fbida";
  version = "2.15-1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    owner = "kraxel";
    repo = "fbida";
    tag = "fbida-${finalAttrs.version}";
    hash = "sha256-iwJkFynhz3SJ8MRjUsKtQAjPCBvST1ezsxTw2ZCXBag=";
  };

  patches = [
    # Prevents using function declaration without explicit parameters.
    ./function-parameters.patch
  ];

  nativeBuildInputs = [
    hexdump
    meson
    ninja
    perl
    pkg-config
  ];

  buildInputs = [
    giflib
    libdrm
    libexif
    libiconvReal
    libinput
    libtsm
    libwebp
    libxkbcommon
    libxpm
    libxt
    motif
    pixman
    poppler
    udev
  ];

  patchPhase = ''
    runHook prePatch

    patchShebangs scripts/*.pl
    patchShebangs scripts/*.sh

    sed -i -E \
      -e '/^jpeg_run[[:space:]]*=.*$/d' \
      -e "/^jpeg_ver[[:space:]]*=.*$/c\\jpeg_ver = '62'" \
      meson.build

    runHook postPatch
  '';

  makeFlags = [
    "HOST=nix"
  ];

  meta = {
    description = "Image viewing and manipulation programs including fbi, fbgs, ida, exiftran and thumbnail.cgi";
    homepage = "https://www.kraxel.org/blog/linux/fbida/";
    downloadPage = "https://gitlab.com/kraxel/fbida/";
    changelog = "https://gitlab.com/kraxel/fbida/-/blob/${finalAttrs.src.tag}/Changes?ref_type=tags";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.linux;
  };
})
