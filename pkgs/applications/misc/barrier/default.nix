{ stdenv, fetchurl, cmake, curl, xorg, avahi, qt5,
  avahiWithLibdnssdCompat ? avahi.override { withLibdnssdCompat = true; }
}:

stdenv.mkDerivation rec {
  name = "barrier-${version}";
  version = "2.1.1";
  src = fetchurl {
    url = "https://github.com/debauchee/barrier/archive/v${version}.tar.gz";
    sha256 = "0x17as5ikfx2r5hawr368a9risvcavyc8zv5g724s709nr6m0pbp";
  };

  buildInputs = [ cmake curl xorg.libX11 xorg.libXext xorg.libXtst avahiWithLibdnssdCompat ];
  propagatedBuildInputs = with qt5; [ qtbase ];

  postFixup = ''
      substituteInPlace "$out/share/applications/barrier.desktop" --replace "Exec=barrier" "Exec=$out/bin/barrier"
    '';

  meta = {
    description = "Open-source KVM software";
    longDescription = ''
      Barrier is KVM software forked from Symless's synergy 1.9 codebase.
      Synergy was a commercialized reimplementation of the original
      CosmoSynergy written by Chris Schoeneman.
    '';
    homepage = https://github.com/debauchee/barrier;
    downloadPage = https://github.com/debauchee/barrier/releases;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.phryneas ];
    platforms = stdenv.lib.platforms.linux;
  };
}
