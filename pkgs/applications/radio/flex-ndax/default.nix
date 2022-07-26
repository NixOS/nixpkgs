{ stdenv, lib, buildGoModule, fetchFromGitHub, libpulseaudio }:

buildGoModule rec {
  pname = "flex-ndax";
  version = "0.2-20220427";

  src = fetchFromGitHub {
    owner = "kc2g-flex-tools";
    repo = "nDAX";
    rev = "v${version}";
    hash = "sha256-KmvTLfGC6xzXcWYAzmBYiYSF65lqMdsdMQjUEk3siqc=";
  };

  buildInputs = [ libpulseaudio ];

  vendorSha256 = "sha256-u/5LiVo/ZOefprEKr/L1+3+OfYb0a4wq+CWoUjYNvzg=";

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/kc2g-flex-tools/nDAX";
    description = "FlexRadio digital audio transport (DAX) connector for PulseAudio";
    license = licenses.mit;
    maintainers = with maintainers; [ mvs ];
  };
}
