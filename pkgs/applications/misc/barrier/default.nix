{ stdenv, fetchFromGitHub, cmake, curl, xorg, avahi, qtbase, mkDerivation,
  avahiWithLibdnssdCompat ? avahi.override { withLibdnssdCompat = true; }
}:

mkDerivation rec {
  pname = "barrier";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "debauchee";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fy7xjwqyisapf8wv50gwpbgbv5b4ldf7766w453h5iw10d18kh0";
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
