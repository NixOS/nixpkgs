{ stdenv
, fetchFromGitHub
, lib
, pkg-config
, gtk3
, gtk-layer-shell
}:

stdenv.mkDerivation {
  pname = "activate-linux-wayland";
  version = "unstable-2023-02-27";

  src = fetchFromGitHub {
    owner = "Kljunas2";
    repo = "activate-linux";
    rev = "8521a85e8b30229635dea58ab053f2b7d674d242";
    hash = "sha256-0O+zo4caMPhcZd4T/iCW4QKchJde9zhTn4nbCOU4nDw=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gtk3
    gtk-layer-shell
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/activate-linux $out/bin/activate-linux

    runHook postInstall
  '';

  meta = with lib; {
    description = "Activate Linux watermark for Wayland";
    homepage = "https://github.com/Kljunas2/activate-linux";
    license = licenses.mit;
    maintainers = with maintainers; [ donovanglover ];
    platforms = platforms.linux;
    mainProgram = "activate-linux";
  };
}
