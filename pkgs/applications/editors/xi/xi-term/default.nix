{ lib, rustPlatform, fetchFromGitHub, wrapXiFrontendHook }:

rustPlatform.buildRustPackage rec {
  name = "xi-term-${version}";
  version = "2018-10-13";

  src = fetchFromGitHub {
    owner = "xi-frontend";
    repo = "xi-term";
    rev = "8a57bea757294a12df9d3ec81ae1319bd0e288cd";
    sha256 = "0sn1jm6hx5dbxmpvgzkwcl6vxl826lk7vnbggxd64zbnhjyijdj8";
  };

  cargoSha256 = "1h49j2r5bh1rjqmss6ccivc2x0ndmamqqzhi6kd02vgrv8jnwxg1";

  buildInputs = [ wrapXiFrontendHook ];

  postInstall = "wrapXiFrontend $out/bin/*";

  meta = with lib; {
    description = "A terminal frontend for Xi";
    homepage = https://github.com/xi-frontend/xi-term;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

