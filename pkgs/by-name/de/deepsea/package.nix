{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "deepsea";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "dsnezhkov";
    repo = pname;
    rev = "v${version}";
    sha256 = "02s03sha8vwp7dsaw3z446pskhb6wmy0hyj0mhpbx58sf147rkig";
  };

  vendorHash = null;

  meta = with lib; {
    description = "Phishing tool for red teams and pentesters";
    longDescription = ''
      DeepSea phishing gear aims to help RTOs and pentesters with the
      delivery of opsec-tight, flexible email phishing campaigns carried
      out on the outside as well as on the inside of a perimeter.
    '';
    homepage = "https://github.com/dsnezhkov/deepsea";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    broken = true; # vendor isn't reproducible with go > 1.17: nix-build -A $name.goModules --check
  };
}
