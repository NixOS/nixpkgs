{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, gtk3
, gtk-layer-shell
}:

buildGoModule rec {
  pname = "nwg-dock";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kLvVP+hwv8Xgvp1YqrXZ2xpEcU92yvNMT5YCcDcg7xQ=";
  };

  vendorHash = "sha256-WDygnKdldZda4GadfStHWsDel1KLdzjVjw0RxmnFPRE=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 gtk-layer-shell ];

  meta = with lib; {
    description = "GTK3-based dock for sway";
    homepage = "https://github.com/nwg-piotr/nwg-dock";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
  };
}
