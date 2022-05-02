{ waylandBuild ? false, lib, fetchFromGitHub, stdenv, xorg, installShellFiles
, cairo, libxkbcommon, wayland, darwin }:

stdenv.mkDerivation rec {
  name = "warpd";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "warpd";
    rev = "v${version}";
    sha256 = "sha256-0Pm6sqJ1ekZoUshKu9JnDFj5dBVRRdAoO8gyJnRMcS4=";
  };

  buildInputs = if waylandBuild then [
    wayland
    cairo
    libxkbcommon
  ] else if stdenv.isDarwin then
    (with darwin.apple_sdk.frameworks; [ ApplicationServices Cocoa ])
  else
    (with xorg; [ libXi libXinerama libXft libXfixes libXtst libX11 libXext ]);

  PLATFORM = if (waylandBuild && stdenv.isDarwin) then
    throw "Wayland not support on Darwin!"
  else if waylandBuild then
    "wayland"
  else
    lib.optionalString stdenv.isDarwin "macos";

  nativeBuildInputs = [ installShellFiles ];

  # TODO: Remove in version higher then 1.2.2
  patches = [ ./usage_printf.patch ];

  installPhase = ''
    mkdir -p $out/bin
    installManPage warpd.1.gz
    install -m755 bin/warpd $out/bin/
  '';

  meta = with lib; {
    description = "A modal keyboard-driven virtual pointer";
    homepage = "https://github.com/rvaiya/warpd";
    platforms = platforms.unix;
    maintainers = with maintainers; [ renesat ];
  };
}
