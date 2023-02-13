{ lib, buildGoModule, fetchFromGitHub, pkg-config, pulseaudio }:

buildGoModule rec {
  pname = "kappanhang";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "nonoo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ycy8avq5s7zspfi0d9klqcwwkpmcaz742cigd7pmcnbbhspcicp";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pulseaudio ];

  vendorSha256 = "1srjngcis42wfskwfqxxj101y9xyzrans1smy53bh1c9zm856xha";

  meta = with lib; {
    homepage = "https://github.com/nonoo/kappanhang";
    description = "Remote control for Icom radio transceivers";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mvs ];
  };
}
