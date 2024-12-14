{
  lib,
  stdenv,
  fetchFromGitHub,
  automake,
  autoconf,
  pkg-config,
  gtk3,
}:

stdenv.mkDerivation rec {
  pname = "gsimplecal";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "dmedvinsky";
    repo = "gsimplecal";
    rev = "v${version}";
    sha256 = "sha256-Q8vK+rIRr+Tzwq0Xw5a1pYoLkSwF6PEdqc3/Dk01++o=";
  };

  postPatch = ''
    sed -i -e '/sys\/sysctl.h/d' src/Unique.cpp
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    automake
    autoconf
  ];
  buildInputs = [ gtk3 ];

  preConfigure = "./autogen.sh";

  meta = {
    homepage = "http://dmedvinsky.github.io/gsimplecal/";
    description = "Lightweight calendar application written in C++ using GTK";
    longDescription = ''
      gsimplecal was intentionally made for use with tint2 panel in the
      openbox environment to be launched upon clock click, but of course it
      will work without it. In fact, binding the gsimplecal to some hotkey in
      you window manager will probably make you happy. The thing is that when
      it is started it first shows up, when you run it again it closes the
      running instance. In that way it is very easy to integrate anywhere. No
      need to write some wrapper scripts or whatever.

      Also, you can configure it to not only show the calendar, but also
      display multiple clocks for different world time zones.
    '';
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.romildo ];
    platforms = lib.platforms.linux;
    mainProgram = "gsimplecal";
  };
}
