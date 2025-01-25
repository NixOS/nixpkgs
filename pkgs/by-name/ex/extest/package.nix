{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "extest";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "extest";
    rev = version;
    hash = "sha256-qdTF4n3uhkl3WFT+7bAlwCjxBx3ggTN6i3WzFg+8Jrw=";
  };

  cargoHash = "sha256-JZPiTzr9KaaqiXKhsGOYmYMtjNzPQzKhqyfSlbeqME8=";

  meta = with lib; {
    description = "X11 XTEST reimplementation primarily for Steam Controller on Wayland";
    homepage = "https://github.com/Supreeeme/extest";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = [ maintainers.puffnfresh ];
  };
}
