{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  lv2,
  sord,
  libx11,
  libxext,
  glew,
  lv2lint,
  pname,
  version,
  sha256,
  description,
  url ? "https://git.open-music-kontrollers.ch/lv2/${pname}.lv2/snapshot/${pname}.lv2-${version}.tar.xz",
  additionalBuildInputs ? [ ],
  postPatch ? "",
  ...
}:

stdenv.mkDerivation {
  inherit pname;

  inherit version;

  inherit postPatch;

  src = fetchurl {
    url = url;
    sha256 = sha256;
  };
  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];
  buildInputs = [
    lv2
    sord
    libx11
    libxext
    glew
    lv2lint
  ]
  ++ additionalBuildInputs;

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = description;
    homepage = "https://open-music-kontrollers.ch/lv2/${pname}:";
    license = lib.licenses.artistic2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.all;
  };
}
