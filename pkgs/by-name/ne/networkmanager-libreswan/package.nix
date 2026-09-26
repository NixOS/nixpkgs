{
  dieHook,
  fetchpatch,
  fetchurl,
  glib,
  gnome,
  gtk3,
  gtk4,
  intltool,
  lib,
  libnl,
  libnma,
  libnma-gtk4,
  libreswan,
  libsecret,
  networkmanager,
  pkg-config,
  replaceVars,
  stdenv,
  withGnome ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "NetworkManager-libreswan";
  version = "1.2.31";

  src = fetchurl {
    url = "mirror://gnome/sources/NetworkManager-libreswan/${lib.versions.majorMinor finalAttrs.version}/NetworkManager-libreswan-${finalAttrs.version}.tar.xz";
    hash = "sha256-5xq3zWruZoOqlDQusm5hQzv/3y2ml4LsptHCmdzDp28=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      ipsec = lib.getExe' libreswan "ipsec";
      inherit libreswan;
    })
  ];

  nativeBuildInputs = [
    dieHook
    glib
    intltool
    pkg-config
  ];

  buildInputs = [
    libnl
    networkmanager
  ]
  ++ lib.optionals withGnome [
    gtk3
    gtk4
    libnma
    libnma-gtk4
    libsecret
  ];

  configureFlags = [
    "--with-gnome=${lib.boolToYesNo withGnome}"
    "--with-gtk4=${lib.boolToYesNo withGnome}"
    "--enable-absolute-paths"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  postPatch = ''
    echo "Ensuring that all helper paths lookups were replaced"
    ! grep -lr nm_libreswan_find_helper --exclude 'utils.[ch]' || die "^ Found non-replaced helper lookup"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "NetworkManager-libreswan";
      attrPath = "networkmanager-libreswan";
    };
    networkManagerPlugin = "VPN/nm-libreswan-service.name";
  };

  meta = {
    description = "NetworkManager's libreswan plugin";
    inherit (networkmanager.meta) maintainers teams platforms;
    license = lib.licenses.gpl2Plus;
  };
})
