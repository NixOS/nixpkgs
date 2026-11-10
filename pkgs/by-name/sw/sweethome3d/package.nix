{
  lib,
  config,
  fetchzip,
  stdenv,
  callPackage,
}:

let
  pname = "sweethome3d";
  version = "7.6.1";

  src = fetchzip {
    url = "mirror://sourceforge/sweethome3d/SweetHome3D-${version}-src.zip";
    hash = "sha256-6ZPQo9ZFiUMeQKagxs2rtyi8r99Wtimt/1tqn60GwPc=";
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
      edwtjo
      DimitarNestorov
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "sweethome3d";
    # last successful hydra build on darwin was in 2025
    broken = stdenv.hostPlatform.isDarwin;
  };

  passthru = lib.optionalAttrs config.allowAliases {
    # Added 2026-11-10
    application = throw "'sweethome3d.application' has been renamed to 'sweethome3d'";
    furniture-editor = throw "'sweethome3d.furniture-editor' has been renamed to 'sweethome3d-furniture-editor'";
    textures-editor = throw "'sweethome3d.textures-editor' has been renamed to 'sweethome3d-textures-editor'";
  };
in
callPackage (if stdenv.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) {
  inherit
    pname
    version
    src
    meta
    patches
    passthru
    ;
}
