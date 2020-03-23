{ stdenv, buildGoModule, fetchFromGitHub, Security }:

buildGoModule rec {
  pname = "hetzner-kube";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "xetys";
    repo = "hetzner-kube";
    rev = version;
    sha256 = "1iqgpmljqx6rhmvsir2675waj78amcfiw08knwvlmavjgpxx2ysw";
  };

  modSha256 = "0jjrk93wdi13wrb5gchhqk7rgwm74kcizrbqsibgkgs2dszwfazh";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  buildFlagsArray = ''
    -ldflags=
    -X github.com/xetys/hetzner-kube/cmd.version=${version}
  '';

  meta = with stdenv.lib; {
    description = "A CLI tool for provisioning Kubernetes clusters on Hetzner Cloud";
    homepage = "https://github.com/xetys/hetzner-kube";
    license = licenses.asl20;
    maintainers = with maintainers; [ eliasp ];
    platforms = platforms.unix;
  };
}
