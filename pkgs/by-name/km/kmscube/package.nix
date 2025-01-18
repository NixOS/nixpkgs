{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  libdrm,
  libX11,
  libGL,
  libgbm,
  pkg-config,
  gst_all_1,
}:

stdenv.mkDerivation {
  pname = "kmscube";
  version = "unstable-2023-09-25";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mesa";
    repo = "kmscube";
    rev = "96d63eb59e34c647cda1cbb489265f8c536ae055";
    hash = "sha256-kpnn4JBNvwatrcCF/RGk/fQ7qiKD26iLBr9ovDmAKBo=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];
  buildInputs =
    [
      libdrm
      libX11
      libGL
      libgbm
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
    ]);

  meta = with lib; {
    description = "Example OpenGL app using KMS/GBM";
    homepage = "https://gitlab.freedesktop.org/mesa/kmscube";
    license = licenses.mit;
    maintainers = with maintainers; [ dezgeg ];
    platforms = platforms.linux;
  };
}
