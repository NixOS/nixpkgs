{
  lib,
  stdenv,
  fetchgit,
  pidgin,
}:

stdenv.mkDerivation rec {
  pname = "pidgin-msn-pecan-crosstalk";
  version = "0.1.4-unstable-2025-08-11";
  src = fetchgit {
    url = "https://git.hiden.cc/CrossTalk/msn-pecan";
    rev = "4d064f7665d41bee757a41f3d0c44a1ba2d3ce03";
    hash = "sha256-Qh73CQVydS/sx5dHuH3onzjDFq/EwKlWbpsYGhKUkfs=";
  };

  meta = with lib; {
    description = "A modified version of the pidgin-msn-pecan libpurple plugin, updated to connect to the CrossTalk service.";
    license = licenses.gpl2Plus;
    homepage = "https://git.hiden.cc/CrossTalk/msn-pecan";
    platforms = platforms.linux;
    maintainers = with maintainers; [ pionaiki ];
  };

  makeFlags = [
    "PURPLE_LIBDIR=${placeholder "out"}/lib/purple-2"
  ];

  installPhase = ''
    mkdir -p "$out/lib/purple-2"
    install -D -m 755 "./libmsn-pecan.so" "$out/lib/purple-2/libmsn-pecan.so"
  '';

  buildInputs = [ pidgin ];
}
