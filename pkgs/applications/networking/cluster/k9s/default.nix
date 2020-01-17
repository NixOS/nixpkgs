{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k9s";
  version = "0.9.3";
  # rev is the release commit, mainly for version command output
  rev = "1a9a83b34cdd0c9b4e793ed6b4b5c16ea1a949a0";

  src = fetchFromGitHub {
    owner  = "derailed";
    repo   = "k9s";
    rev    = version;
    sha256 = "0k27mfccz563r18zlbaxll305vrmrx19ym6znsikvqxlmhy86g36";
  };

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/derailed/k9s/cmd.version=${version}
      -X github.com/derailed/k9s/cmd.commit=${rev}
  '';

  modSha256 = "09rwbl8zd06ax5hidm5l1schwqvsr5ndlqh09w1rq9fqjijy649y";

  meta = with stdenv.lib; {
    description = "Kubernetes CLI To Manage Your Clusters In Style.";
    homepage = https://github.com/derailed/k9s;
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih ];
  };
}
