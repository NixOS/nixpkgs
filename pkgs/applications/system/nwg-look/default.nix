# users.mutableUsers must be true in configuration.nix or the program will crash when saving settings
{lib, buildGoModule, fetchFromGitHub, pkg-config, go, gtk3, xcur2png, glib, cairo }:

buildGoModule rec {
  pname = "nwg-look";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "0zz4bz31r1m3ckmgdpbi0p69sca43c3zpbaa19pxp3lnixcr3542";
  };
  nativeBuildInputs = [ pkg-config go ];
  buildInputs = [ gtk3 xcur2png glib cairo ];
  vendorSha256 = "sha256-XEgPeJ8zlaadl+yuAOlbzsBECs/c8cjBja+sZkTsg60=";
  postPatch = ''
    substituteInPlace ./main.go --replace \
    /usr/share/${pname}/main.glade $out/share/${pname}/main.glade
  '';

  postInstall = ''
    install -D --mode=444 ./stuff/main.glade $out/share/${pname}/main.glade
    install -D --mode=444 ./stuff/${pname}.desktop $out/share/applications/${pname}.desktop
    install -D --mode=444 ./stuff/${pname}.svg $out/share/pixmaps/${pname}.svg
  '';

  meta = with lib; {
    description = "GTK3 settings editor adapted to work in the sway / wlroots environment";
    homepage = "https://github.com/nwg-piotr/nwg-look";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ bnhrkn ];
  };
}
