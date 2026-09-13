{
  stdenv,
  lib,
  fetchFromCodeberg,
  zig_0_16,
  linkFarm,
  fetchgit,
}:
let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gameconf";
  version = "1.0.0";

  src = fetchFromCodeberg {
    owner = "JeppeUseNixos";
    repo = "gameconf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6K4s1dy9+kcw1SfduCsxYByK7buXa6cVDX/Xu9Dhifs=";
  };

  nativeBuildInputs = [ zig.hook ];

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-Rem8TXZz/UFgqqN8D+3SeTgBc5XFdhTIwpoVy+mJHOQ=";
  };
  #zigBuildFlags = [
  #  "--system"
  #  "${finalAttrs.zigDeps}"
  #];

  strictDeps = true;
  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  __structuredAttrs = true;

  meta = {
    homepage = "https://codeberg.org/JeppeUseNixos/gameconf";
    description = "Tool for configuring steam games";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jeppe ];
    platforms = lib.platforms.linux;
  };

})
