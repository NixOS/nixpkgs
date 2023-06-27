{ mkDerivation
, fetchurl
, lib
, extra-cmake-modules
, kdoctools
, wrapGAppsHook
, exiv2
, ffmpeg
, libkdcraw
, phonon
, libvlc
, kconfig
, kiconthemes
, kio
, kinit
, kpurpose
}:

mkDerivation rec {
  pname = "kphotoalbum";
  version = "5.10.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-rdEXgg5hwu52XJit07AbrSw7kLDNK+IpbIwKCV/Lhp8=";
  };

  # not sure if we really need phonon when we have vlc, but on KDE it's bound to
  # be on the system anyway, so there is no real harm including it
  buildInputs = [ exiv2 phonon libvlc ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [ kconfig kiconthemes kio kinit kpurpose libkdcraw ];

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ ffmpeg ]}"
  ];

  meta = with lib; {
    description = "Efficient image organization and indexing";
    homepage = "https://www.kphotoalbum.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (kconfig.meta) platforms;
  };
}
