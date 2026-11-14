{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "sw";
  version = "0-unstable-2026-04-04";

  src = fetchFromGitHub {
    owner = "pd2s";
    repo = "sw";
    rev = "fe226c9de2c5034eb13aa0d76ecf73d81fabdec0";
    hash = "sha256-uWKJfJXVfUQrdThnBURloTLDQpn138wpIOHXKQg2E7c=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  buildPhase = ''
    mkdir -p $out/include $out/lib64/pkgconfig

    BUILD_PATH=/build HEADER_INSTALL_PATH=$out/include LIBRARY_INSTALL_PATH=$out/lib64 PKGCONFIG_INSTALL_PATH=$out/lib64/pkgconfig ./build.sh install
  '';

  meta = {
    description = "Simple/suckless widgets";
    homepage = "https://github.com/pd2s/sw";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.corbinwunderlich ];
  };
}
