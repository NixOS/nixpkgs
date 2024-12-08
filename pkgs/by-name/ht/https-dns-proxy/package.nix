{ lib, stdenv, fetchFromGitHub, cmake, gtest, c-ares, curl, libev }:

let
  # https-dns-proxy supports HTTP3 if curl has support, but as of 2022-08 curl doesn't work with that enabled
  # curl' = (curl.override { http3Support = true; });
  curl' = curl;

in
stdenv.mkDerivation rec {
  pname = "https-dns-proxy";
  # there are no stable releases (yet?)
  version = "unstable-2022-05-05";

  src = fetchFromGitHub {
    owner = "aarond10";
    repo = "https_dns_proxy";
    rev = "d310a378795790350703673388821558163944de";
    hash = "sha256-On4SKUeltPhzM/x+K9aKciKBw5lmVySxnmLi2tnKr3Y=";
  };

  postPatch = ''
    substituteInPlace https_dns_proxy.service.in \
      --replace "\''${CMAKE_INSTALL_PREFIX}/" ""
    substituteInPlace munin/https_dns_proxy.plugin \
      --replace '--unit https_dns_proxy.service' '--unit https-dns-proxy.service'
  '';

  nativeBuildInputs = [ cmake gtest ];

  buildInputs = [ c-ares curl' libev ];

  postInstall = ''
    install -Dm444 -t $out/share/doc/${pname} ../{LICENSE,*.md}
    install -Dm444 -t $out/share/${pname}/munin ../munin/*
    # the systemd service definition is garbage, and we use our own with NixOS
    mv $out/lib/systemd $out/share/${pname}
    rmdir $out/lib
  '';

  # upstream wants to add tests and the gtest framework is in place, so be ready
  # for when that happens despite there being none as of right now
  doCheck = true;

  meta = with lib; {
    description = "DNS to DNS over HTTPS (DoH) proxy";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
    mainProgram = "https_dns_proxy";
  };
}
