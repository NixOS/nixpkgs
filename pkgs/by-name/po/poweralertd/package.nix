{
  lib,
  stdenv,
  fetchFromSourcehut,
  meson,
  ninja,
  pkg-config,
  scdoc,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "poweralertd";
  version = "0.3.0";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "poweralertd";
    rev = finalAttrs.version;
    hash = "sha256-WzqThv3Vu8R+g6Bn8EfesRk18rchCvw/UMPwbn9YC80=";
  };

  postPatch = ''
    substituteInPlace meson.build --replace-fail "systemd.get_pkgconfig_variable('systemduserunitdir')" "'${placeholder "out"}/lib/systemd/user'"
  '';

  buildInputs = [
    systemd
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  depsBuildBuild = [
    scdoc
    pkg-config
  ];

  meta = {
    description = "UPower-powered power alerter";
    homepage = "https://git.sr.ht/~kennylevinsen/poweralertd";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ thibautmarty ];
    mainProgram = "poweralertd";
  };
})
