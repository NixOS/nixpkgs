{ lib
, stdenv
, fetchurl
, libsndfile
, wxGTK32
, SDL
}:

stdenv.mkDerivation rec {
  pname = "pterm";
  version = "6.0.4";

  buildInputs = [ libsndfile SDL wxGTK32 ];

  src = fetchurl {
    url = "https://www.cyber1.org/download/linux/pterm-${version}.tar.bz2";
    hash = "sha256-0OJvoCOGx/a51Ja7n3fOTeQJEcdyn/GhaJ0NtVCyuC8=";
  };

  patches = [ ./0001-dtnetsubs-remove-null-check.patch ];

  preBuild = ''
    substituteInPlace Makefile.common Makefile.wxpterm --replace "/bin/echo" "echo"
    echo "exit 0" > wxversion.py
  '';

  hardeningDisable = [ "format" ];

  env.PTERMVERSION = "${version}";

  installPhase = ''
    runHook preInstall

    install -Dm755 "pterm" "$out/bin/pterm"

    runHook postInstall
  '';

  meta = with lib; {
    description = "terminal emulator for the Cyber1 mainframe-based CYBIS system";
    homepage = "https://www.cyber1.org/";
    license = licenses.zlib;
    maintainers = with maintainers; [ sarcasticadmin ];
    mainProgram = "pterm";
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
