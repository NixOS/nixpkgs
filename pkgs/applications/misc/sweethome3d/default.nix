{
  lib,
  fetchzip,
  stdenv,
  callPackage,
}:

let
  pname = "sweethome3d";
  version = "7.5";

  src = fetchzip {
    url = "mirror://sourceforge/sweethome3d/SweetHome3D-${version}-src.zip";
    hash = "sha256-+rAhq5sFXC34AMYCcdAYZzrUa3LDy4S5Zid4DlEVvTQ=";
  };

  patches = [
    ./build-xml.patch
    ./config.patch
  ];

  meta = {
    homepage = "https://www.sweethome3d.com/index.jsp";
    description = "Design and visualize your future home";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      DimitarNestorov
    ];
    platforms = [
      "i686-linux"
      "x86_64-darwin"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "sweethome3d";
  };
in
{
  application =
    if stdenv.hostPlatform.isDarwin then
      callPackage ./darwin.nix {
        inherit
          pname
          version
          src
          meta
          patches
          ;
      }
    else
      callPackage ./linux.nix {
        inherit
          pname
          version
          src
          meta
          patches
          ;
      };
}
