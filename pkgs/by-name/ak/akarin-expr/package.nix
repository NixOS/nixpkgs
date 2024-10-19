{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  llvm_18,
  pkg-config,
  vapoursynth,
  ninja,
  libxml2,
}:

stdenv.mkDerivation {
  pname = "akarin-expr";
  version = "0.95";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-plugin";
    rev = "6d7c733b3014a42be75299427b5c35f56f02a47a";
    hash = "sha256-MlQ0iOYPMAGttOVD2yF4kyZE+cpQ240DC2TBJY8/pH4=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    llvm_18
    vapoursynth
    libxml2
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail \
        "install_dir: join_paths(vapoursynth_dep.get_pkgconfig_variable('libdir'), 'vapoursynth')," \
        "install_dir: join_paths('${placeholder "out"}/lib/', 'vapoursynth'),"
  '';

  meta = {
    description = "Experimental VapourSynth plugin";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/akarin-vapoursynth-plugin";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.lgpl3Only;
  };
}
