{
  lib,
  clangStdenv,
  fetchzip,
  cairo,
  fetchpatch,
  fontconfig,
  freetype,
  gnustep-gui,
  libxft,
  libxmu,
  pkg-config,
  withGershwinPatches ? false,
  wrapGNUstepAppsHook,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "gnustep-back";
  version = "0.32.0";

  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-E9rg3ySRUXSVgdPLeg1WrMO8u+SHHmM2Kb/XDAYqIOQ=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGNUstepAppsHook
  ];

  buildInputs = [
    cairo
    fontconfig
    freetype
    libxft
    libxmu
  ];

  patches = lib.optionals withGershwinPatches [
    (fetchpatch {
      name = "inter-bold.patch";
      url = "https://raw.githubusercontent.com/gershwin-desktop/gershwin-developer/54f56923a7c47fc721c51e6195369a98f5e55661/Library/Patches/libs-back/inter-bold.patch";
      sha256 = "sha256-jau7Npjy/aGfBK3SC0ub/ZJS2oz3rUIeUPZZaks5nho=";
    })
    (fetchpatch {
      name = "net-wm-pid.patch";
      url = "https://raw.githubusercontent.com/gershwin-desktop/gershwin-developer/5983da933e19dc6c84498501314cde0310961c73/Library/Patches/libs-back/net-wm-pid.patch";
      sha256 = "sha256-hB6NobYKZIlhR728TDObU8CN/6Slzf7DawPHicZfE4o=";
    })
  ];

  propagatedBuildInputs = [ gnustep-gui ];

  meta = {
    description = "Generic backend for GNUstep";
    mainProgram = "gpbs";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [
      ashalkhakov
      dblsaiko
    ];
    platforms = lib.platforms.linux;
  };
})
