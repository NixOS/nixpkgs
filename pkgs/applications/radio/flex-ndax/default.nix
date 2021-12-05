{ lib, buildGoModule, fetchFromGitHub, pulseaudio }:

buildGoModule rec {
  pname = "flex-ndax";
  version = "0.2-20211111.0";

  src = fetchFromGitHub {
    owner = "kc2g-flex-tools";
    repo = "nDAX";
    rev = "v${version}";
    sha256 = "0m2hphj0qvgq25pfm3s76naf672ll43jv7gll8cfs7276ckg1904";
  };

  buildInputs = [ pulseaudio ];

  vendorSha256 = "1bf0iidb8ggzahy3fvxispf3g940mv6vj9wqd8i3rldc6ca2i3pf";

  meta = with lib; {
    homepage = "https://github.com/kc2g-flex-tools/nDAX";
    description =
      "FlexRadio digital audio transport (DAX) connector for PulseAudio";
    license = licenses.mit;
    maintainers = with maintainers; [ mvs ];
  };
}
