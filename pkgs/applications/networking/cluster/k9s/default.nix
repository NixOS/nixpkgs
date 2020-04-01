{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k9s";
  version = "0.17.7";
  # rev is the release commit, mainly for version command output
  rev = "8fedc42304ce33df314664eb0c4ac73be59065af";

  src = fetchFromGitHub {
    owner  = "derailed";
    repo   = "k9s";
    rev    = "v${version}";
    sha256 = "0bqx1ckk89vzmk6fmqmv03cbdvw0agwrqzywzw35b4n0di37x0nv";
  };

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/derailed/k9s/cmd.version=${version}
      -X github.com/derailed/k9s/cmd.commit=${rev}
  '';

  modSha256 = "06m4xgl29zx6zpqx630m9cm52wmljms9cvly5f4pqdb4zicq7n86";

  meta = with stdenv.lib; {
    description = "Kubernetes CLI To Manage Your Clusters In Style.";
    homepage = "https://github.com/derailed/k9s";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih ];
  };
}
