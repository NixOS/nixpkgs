{
  lib,
  stdenv,
  fetchFromGitLab,
  sane-backends,
  sane-frontends,
  libX11,
  gtk2,
  pkg-config,
  libpng,
  libusb-compat-0_1,
  gimpSupport ? false,
  gimp,
  nix-update-script,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "xsane";
  version = "0.999";

  src = fetchFromGitLab {
    owner = "frontend";
    group = "sane-project";
    repo = pname;
    rev = version;
    hash = "sha256-oOg94nUsT9LLKnHocY0S5g02Y9a1UazzZAjpEI/s+yM=";
  };

  patches = [
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/xsane/raw/rawhide/f/xsane-0.998-libpng.patch";
      hash = "sha256-0z292+Waa2g0PCQpUebdWprl9VDyBOY0XgqMJaIcRb8=";
    })
  ];

  preConfigure = ''
    sed -e '/SANE_CAP_ALWAYS_SETTABLE/d' -i src/xsane-back-gtk.c
    chmod a+rX -R .
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libpng
    libusb-compat-0_1
    sane-backends
    sane-frontends
    libX11
    gtk2
  ] ++ lib.optional gimpSupport gimp;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "http://www.sane-project.org/";
    description = "Graphical scanning frontend for sane";
    mainProgram = "xsane";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ melling ];
  };
}
