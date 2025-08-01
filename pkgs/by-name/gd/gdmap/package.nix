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
  version = "1.3.1";

  src = fetchFromGitLab {
    owner = "sjohannes";
    repo = "gdmap";
    tag = "v1.3.1";
    sha256 = "sha256-dgZ+EDk7O+nuqrBsTPVW7BHufvkqLnWbXrIOOn7YlW4=";
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
    description = "Tool to visualize disk space (GTK 3 port of Original)";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    mainProgram = "gdmap";
  };
}
