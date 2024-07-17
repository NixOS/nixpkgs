{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  intltool,
  perlPackages,
  goffice,
  gnome,
  adwaita-icon-theme,
  wrapGAppsHook3,
  gtk3,
  bison,
  python3Packages,
  itstool,
}:

let
  inherit (python3Packages) python pygobject3;
in
stdenv.mkDerivation rec {
  pname = "gnumeric";
  version = "1.12.57";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "r/ULG2I0DCT8z0U9X60+f7c/S8SzT340tsPS2a9qHk8=";
  };

  configureFlags = [ "--disable-component" ];

  nativeBuildInputs = [
    pkg-config
    intltool
    bison
    itstool
    wrapGAppsHook3
  ];

  # ToDo: optional libgda, introspection?
  buildInputs =
    [
      goffice
      gtk3
      adwaita-icon-theme
      python
      pygobject3
    ]
    ++ (with perlPackages; [
      perl
      XMLParser
    ]);

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "GNOME Office Spreadsheet";
    license = lib.licenses.gpl2Plus;
    homepage = "http://projects.gnome.org/gnumeric/";
    platforms = platforms.unix;
    broken = with stdenv; isDarwin && isAarch64;
    maintainers = [ maintainers.vcunat ];
  };
}
