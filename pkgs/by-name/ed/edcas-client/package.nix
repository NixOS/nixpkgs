{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, cmake
, wayland
, libX11, libXcursor, libXi, libXrandr
, libxkbcommon, libxcb
, libglvnd 
}:

let
  rpathLibs = [
    libglvnd
    libXcursor
    libXi
    libxkbcommon
    libXrandr
    libX11
    wayland
  ];
in rustPlatform.buildRustPackage rec {
  pname = "edcas-client";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "arne-fuchs";
    repo = pname;
    rev = version;
    sha256 = "sha256-1IkaulUeTdAbLSaVmINaAMrfAK5SSGFpW2l04PPZylA=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };
  
  cargoSha256 = "sha256-zYgNPlKCQ3g5p9W2jdcX/O21tCmklJh3om1oEOfo0QE=";

  buildInputs = [
    libxcb
    libX11
    libxkbcommon
    openssl
  ];
  
  nativeBuildInputs = [ 
    pkg-config 
    cmake 
    rustPlatform.bindgenHook 
  ];

  postPatch = ''
    substituteInPlace ./src/app/materials.rs --replace '/usr/share/edcas-client/' "$out/usr/share/"
    substituteInPlace ./src/app/settings.rs --replace '/etc/edcas-client/' "$out/etc/"
    substituteInPlace ./src/app/about.rs --replace '/usr/share/edcas-client/' "$out/"
    substituteInPlace ./src/app/news.rs --replace '/usr/share/edcas-client/' "$out/"
    substituteInPlace ./src/main.rs --replace '/usr/share/edcas-client/' "$out/"
  '';

  postFixup = ''
    patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}:$(patchelf --print-rpath $out/bin/edcas-client)" $out/bin/edcas-client
  '';

  postInstall = ''
    mkdir -p $out/etc/ $out/usr/share $out/graphics/logo
    
    install -Dm644 $src/graphics/logo/edcas_128.png $src/graphics/logo/edcas.png "$out/graphics/logo"
    install -Dm644 $src/settings-example.json "$out/etc/settings-example.json"
    install -Dm644 $src/materials.json "$out/usr/share/materials.json"
  '';

  meta = with lib; {
    homepage = "https://github.com/arne-fuchs/edcas-client/";
    description = "Compact information dashboard for Elite Dangerous game";
    license = licenses.asl20;
    platforms = platforms.linux;
    mainProgram = "edcas-client";
    maintainers = with maintainers; [ pabloaul ];
  };

}
