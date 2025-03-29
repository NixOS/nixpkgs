{
  lib,
  fetchFromGitHub,
  rustPlatform,
  wrapGAppsHook3,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "mpv-subs-popout";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "sdaqo";
    repo = "mpv-subs-popout";
    rev = "v${version}";
    hash = "sha256-Z8IWiYKitkbEFdjca5G6P0I6j4Fg2fIHco6fD90UoBw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-n7e3VrnueU7Lsj/FwM0aC9ThTqUlq27SS3RKugduwEA=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [ openssl ];

  meta = {
    description = "A little application that makes it possible to display mpv's subs anywhere you want. With translation features";
    homepage = "https://github.com/sdaqo/mpv-subs-popout";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.sdaqo ];
    platforms = lib.platforms.linux;
  };
}
