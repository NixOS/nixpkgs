{
  lib,
  stdenv,
  fetchgit,
  libx11,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "seturgent";
  version = "1.5";

  src = fetchgit {
    url = "git://git.codemadness.org/seturgent";
    rev = finalAttrs.version;
    sha256 = "sha256-XW7ms0BVCf1/fuL3PJ970t6sHkmMY1iLYXfS9R60JX0=";
  };

  buildInputs = [
    libx11
    xorgproto
  ];

  installPhase = ''
    mkdir -pv $out/bin
    mv seturgent $out/bin
  '';

  meta = {
    platforms = lib.platforms.linux;
    description = "Set an application's urgency hint (or not)";
    mainProgram = "seturgent";
    maintainers = with lib.maintainers; [ yarr ];
    homepage = "https://codemadness.org/seturgent-set-urgency-hints-for-x-applications.html";
    license = lib.licenses.mit;
  };
})
