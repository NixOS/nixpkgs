{ lib, fetchFromGitHub, cmake, curl, xorg, avahi, qtbase, mkDerivation,
  openssl, wrapGAppsHook,
  avahiWithLibdnssdCompat ? avahi.override { withLibdnssdCompat = true; }
}:

mkDerivation rec {
  pname = "barrier";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "debauchee";
    repo = pname;
    rev = "v${version}";
    sha256 = "11vqkzpcjiv3pq6ps022223j6skgm1d23dj18n4a5nsf53wsvvp4";
    fetchSubmodules = true;
  };

  buildInputs = [ curl xorg.libX11 xorg.libXext xorg.libXtst avahiWithLibdnssdCompat qtbase ];
  nativeBuildInputs = [ cmake wrapGAppsHook ];

  postFixup = ''
    substituteInPlace "$out/share/applications/barrier.desktop" --replace "Exec=barrier" "Exec=$out/bin/barrier"
  '';

  qtWrapperArgs = [
    ''--prefix PATH : ${lib.makeBinPath [ openssl ]}''
  ];

  meta = {
    description = "Open-source KVM software";
    longDescription = ''
      Barrier is KVM software forked from Symless's synergy 1.9 codebase.
      Synergy was a commercialized reimplementation of the original
      CosmoSynergy written by Chris Schoeneman.
    '';
    homepage = "https://github.com/debauchee/barrier";
    downloadPage = "https://github.com/debauchee/barrier/releases";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.phryneas ];
    platforms = lib.platforms.linux;
  };
}
