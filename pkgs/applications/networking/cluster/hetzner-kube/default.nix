{ lib, buildGoModule, fetchFromGitHub }:

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

  buildFlagsArray = ''
    -ldflags=
    -X github.com/xetys/hetzner-kube/cmd.version=${version}
  '';

  meta = {
    description = "A CLI tool for provisioning Kubernetes clusters on Hetzner Cloud";
    homepage = "https://github.com/xetys/hetzner-kube";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eliasp ];
    platforms = lib.platforms.unix;
  };
}
