{ stdenv, fetchFromGitHub, cmake, curl, xorg, avahi, qtbase, mkDerivation,
  openssl, wrapGAppsHook,
  avahiWithLibdnssdCompat ? avahi.override { withLibdnssdCompat = true; }
}:

mkDerivation rec {
  pname = "barrier";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "debauchee";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gbg3p7c0vcsdzsjj1ssx6k8xpj3rpyvais12266f0xvnbvihczd";
  };

  buildInputs = [ curl xorg.libX11 xorg.libXext xorg.libXtst avahiWithLibdnssdCompat qtbase ];
  nativeBuildInputs = [ cmake wrapGAppsHook ];

  postFixup = ''
    substituteInPlace "$out/share/applications/barrier.desktop" --replace "Exec=barrier" "Exec=$out/bin/barrier"
  '';

  qtWrapperArgs = [
    ''--prefix PATH : ${stdenv.lib.makeBinPath [ openssl ]}''
  ];

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
