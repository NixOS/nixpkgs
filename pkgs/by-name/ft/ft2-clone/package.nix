{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nixosTests,
  alsa-lib,
  SDL2,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "ft2-clone";
  version = "1.99";

  src = fetchFromGitHub {
    owner = "8bitbubsy";
    repo = "ft2-clone";
    rev = "v${version}";
    hash = "sha256-7FA6pd8rnobvOWHqHqJseJgUniAYhpzqmJnmqYyvpm0=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    SDL2
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux alsa-lib
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  postInstall = ''
    install -Dm444 "$src/release/other/Freedesktop.org Resources/Fasttracker II clone.desktop" \
      $out/share/applications/ft2-clone.desktop
    install -Dm444 "$src/release/other/Freedesktop.org Resources/Fasttracker II clone.png" \
      $out/share/icons/hicolor/512x512/apps/ft2-clone.png
    # gtk-update-icon-cache does not like whitespace. Note that removing this
    # will not make the build fail, but it will make the NixOS test fail.
    substituteInPlace $out/share/applications/ft2-clone.desktop \
      --replace-fail "Icon=Fasttracker II clone" Icon=ft2-clone
  '';

  passthru.tests = {
    ft2-clone-starts = nixosTests.ft2-clone;
  };

  meta = {
    description = "Highly accurate clone of the classic Fasttracker II software for MS-DOS";
    homepage = "https://16-bits.org/ft2.php";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fgaz ];
    # From HOW-TO-COMPILE.txt:
    # > This code is NOT big-endian compatible
    platforms = lib.platforms.littleEndian;
    mainProgram = "ft2-clone";
  };
}
