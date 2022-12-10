{ lib, buildGoModule, fetchFromGitHub, pkg-config, gtk3, gtk-layer-shell }:

buildGoModule rec {
  pname = "nwg-bar";
  version = "unstable-2021-09-23";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "7dd7df3cd9a9e78fe477e88e0f3cb97309d50ff5";
    sha256 = "sha256-piysF19WDjb/EGI9MBepYrOrQL9C1fsoq05AP8CYN58=";
  };

  patches = [ ./fix-paths.patch ];
  postPatch = ''
    substituteInPlace config/bar.json --subst-var out
    substituteInPlace tools.go --subst-var out
  '';

  vendorSha256 = "sha256-dgOwflNRb+11umFykozL8DQ50dLbhbMCmCyKmLlW7rw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 gtk-layer-shell ];

  preInstall = ''
    mkdir -p $out/share/nwg-bar
    cp -r config/* images $out/share/nwg-bar
  '';

  meta = with lib; {
    description =
      "GTK3-based button bar for sway and other wlroots-based compositors";
    homepage = "https://github.com/nwg-piotr/nwg-bar";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sei40kr ];
  };
}
