{ stdenv, fetchFromGitHub, buildGoModule, go }:

buildGoModule rec {
  pname = "kubelogin";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jw8v6ff0iwkwxlhcr35cvhy4zg31dsm1s3q4fxgi901yj1wn6zy";
  };

  vendorSha256 = "0al8y65xvnwl34jkpqyf6zwr21xn30zswknlym9nnn1n47fyayxb";

  buildFlagsArray = ''
    -ldflags=
        -X main.version=${version}
        -X main.goVersion=${stdenv.lib.getVersion go}
  '';

  meta = with stdenv.lib; {
    description = "A Kubernetes credential plugin implementing Azure authentication";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ yurrriq ];
  };
}
