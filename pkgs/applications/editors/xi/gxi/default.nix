{ stdenv, fetchFromGitHub, rustPlatform, cmake, pkgconfig, freetype, gtk3, wrapGAppsHook, wrapXiFrontendHook }:

rustPlatform.buildRustPackage rec {
  name = "gxi-unstable-${version}";
  version = "2018-08-27";
  
  src = fetchFromGitHub {
    owner = "bvinc";
    repo = "gxi";
    rev = "a35d2cf6c5f1ac71387caf6fc33f158454a89f25";
    sha256 = "1yg9mglxssavmcyvi38mjsmzsgrls2ridnphvwrxgzgnw7293wav";
  };

  nativeBuildInputs = [ cmake pkgconfig freetype ];

  buildInputs = [
    gtk3
    wrapGAppsHook
    wrapXiFrontendHook
  ];

  cargoSha256 = "0v72s58g0v69gpja8n0sxzpc821849p6q53pmyasbrnjhyh51nxw";

  postInstall = "wrapXiFrontend $out/bin/*";

  meta = with stdenv.lib; {
    description = "GTK frontend for the xi text editor, written in rust";
    homepage = https://github.com/bvinc/gxi;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
