{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libgpiod
, cmake
}:

stdenv.mkDerivation rec {
  pname = "gcfflasher";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "dresden-elektronik";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-o0S4NtgQ/Rlpmkk8pTocmP0N+5F7BX8lUsczOKjujwk=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    libgpiod
  ];

  installPhase = ''
    runHook preInstall
    install -Dm0755 GCFFlasher $out/bin/GCFFlasher
    runHook postInstall
  '';

  meta = with lib; {
    description = "CFFlasher is the tool to program the firmware of dresden elektronik's Zigbee products";
    license = licenses.bsd3;
    homepage = "https://github.com/dresden-elektronik/gcfflasher";
    maintainers = with maintainers; [ fleaz ];
    platforms = platforms.all;
    mainProgram = "GCFFlasher";
  };
}
