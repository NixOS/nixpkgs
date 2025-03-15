{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  cairo,
  gtk3,
  ninja,
  pkg-config,
  libxml2,
  gettext,
}:

stdenv.mkDerivation {
  pname = "gdmap";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "sjohannes";
    repo = "gdmap";
    tag = "v1.2.0";
    sha256 = "1p96pps4yflj6a42g61pcqpllx7vcjlh417kwjy0b4mqp16vmrzr";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    gtk3
    cairo
    libxml2
    gettext
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/sjohannes/gdmap";
    description = "A tool to visualize disk space (GTK 3 port of Original)";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    mainProgram = "gdmap";
  };
}
