{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  libsoup_3,
  libxml2,
  meson,
  ninja,
  gnome,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "phodav";
  version = "3.0";

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/phodav/${version}/phodav-${version}.tar.xz";
    sha256 = "OS7C0G1QMA3P8e8mmiqYUwTim841IAAvyiny7cHRONE=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    udevCheckHook
  ];

  buildInputs = [
    libsoup_3
    libxml2
  ];

  mesonFlags = [
    "-Davahi=disabled"
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "-Dgtk_doc=disabled"
    "-Dudevrulesdir=${placeholder "out"}/lib/udev/rules.d"
  ];

  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-lintl";

  doInstallCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  # We need to do this in pre-configure before the data/ folder disappears.
  preConfigure = ''
    install -vDt $out/lib/udev/rules.d/ data/*-spice-webdavd.rules
  '';

  meta = with lib; {
    description = "WebDav server implementation and library using libsoup";
    homepage = "https://gitlab.gnome.org/GNOME/phodav";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
