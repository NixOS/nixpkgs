{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  sane-backends,
  libX11,
  gtk2,
  pkg-config,
  libusb-compat-0_1 ? null,
}:

stdenv.mkDerivation rec {
  pname = "sane-frontends";
  version = "1.0.14";

  src = fetchurl {
    url = "https://alioth-archive.debian.org/releases/sane/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "1ad4zr7rcxpda8yzvfkq1rfjgx9nl6lan5a628wvpdbh3fn9v0z7";
  };

  # add all fedora patchs. fix gcc-14 build among other things
  # https://src.fedoraproject.org/rpms/sane-frontends/tree/main
  patches =
    let
      fetchFedoraPatch =
        { name, hash }:
        fetchpatch {
          inherit name hash;
          url = "https://src.fedoraproject.org/rpms/sane-frontends/raw/89f752d7e236e86be8d64b7ac6991a36f9e9f7d0/f/${name}";
        };
    in
    map fetchFedoraPatch [
      {
        name = "0001-src-scanadf.c-Fix-segfault-when-scanadf-h-d-device.patch";
        hash = "sha256-sSUWm5fL7YTebzXh3Thb/qwgr7d++1Y+74uI8R5oF0g=";
      }
      {
        name = "frontends-scanadf-segv.patch";
        hash = "sha256-VRag9nMk8ZCjg9Oq0siHdT8J6sbNjq9cU2ktOH2vkLo=";
      }
      {
        name = "sane-frontends-1.0.14-array-out-of-bounds.patch";
        hash = "sha256-a0lzbAogSrXsK5jVeNffDS+zFxpuDHXpHQlOJ5874+U=";
      }
      {
        name = "sane-frontends-1.0.14-sane-backends-1.0.20.patch";
        hash = "sha256-ViYjxXGj58P6EaZ+fIiAydrgbyS1ivn39uN3EWcvnZg=";
      }
      {
        name = "sane-frontends-1.0.14-xcam-man.patch";
        hash = "sha256-HGANgQPujn/jjOMGs9LlzYvYZphMWwbsI74NCad5ADc=";
      }
      {
        name = "sane-frontends-c99.patch";
        hash = "sha256-LPELEG11wEom05ECAMgXUDRWvrbuU4nT3apuS1eITyA=";
      }
      {
        name = "sane-frontends-configure-c99.patch";
        hash = "sha256-SPvMDCZv8VRGP+cXRFjVbqgbTeVhdLOTEQbbBgSMLvY=";
      }
    ];

  buildInputs = [
    sane-backends
    libX11
    gtk2
  ]
  ++ lib.optional (libusb-compat-0_1 != null) libusb-compat-0_1;
  nativeBuildInputs = [ pkg-config ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Scanner Access Now Easy";
    homepage = "http://www.sane-project.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
