{ stdenv, fetchFromGitHub, cmake, curl, xorg, avahi, qtbase, mkDerivation,
  avahiWithLibdnssdCompat ? avahi.override { withLibdnssdCompat = true; }
}:

mkDerivation rec {
  pname = "barrier";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "debauchee";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dakpgs4jcwg06f45xg6adc83jd2qnpywmjm1z7g0hzd2vd0qg4k";
  };

  buildInputs = [ cmake curl xorg.libX11 xorg.libXext xorg.libXtst avahiWithLibdnssdCompat qtbase ];

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
