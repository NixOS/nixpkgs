{ lib
, rustPlatform
, fetchFromSourcehut
, fetchpatch
, libGL
, vulkan-loader
, wayland
, wayland-protocols
, libxkbcommon
, libX11
, libXrandr
, libXi
, libXcursor
, scdoc
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "auslogger";
  version = "0.1.4";

  src = fetchFromSourcehut {
    owner = "~mastersoft";
    vc = "git";
    repo = "Auslogger";
    rev = "v${version}";
    sha256 = "sha256-Tw3KL90RUkXtYBuV4JtbyAywRFFYH+K5korKoUEqCcQ=";
  };

  cargoSha256 = "sha256-7YZJ9EhUn4CvXQQILpUcjTQrOv/ZHwh2Wx1HYlD6rgo=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
    libX11
    libXrandr
    libXi
    libXcursor
  ];

  preFixup = ''
    runHook preInstall
    installManPage man/auslogger.1
    runHook postInstall
  '';

  postFixup =
    let
      libPath = lib.makeLibraryPath [
        libGL
        vulkan-loader
        wayland
        wayland-protocols
        libxkbcommon
        libX11
        libXrandr
        libXi
        libXcursor
      ];
    in
    ''
      patchelf --set-rpath "${libPath}" "$out/bin/auslogger"
    '';

  meta = with lib; {
    # Linux only
    platforms = lib.platforms.unix;
    description = "A simple program for locking, restarting and shutting down. Designed for tiling window managers.";
    homepage = "https://sr.ht/~mastersoft/Auslogger";
    license = licenses.gpl3;
    maintainers = with maintainers; [ drzoidberg ];
  };
}
