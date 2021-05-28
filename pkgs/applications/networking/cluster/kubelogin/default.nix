{ stdenv, fetchFromGitHub, buildGoModule, go }:

buildGoModule rec {
  pname = "kubelogin";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
    sha256 = "18rkjdl8asr5c1kgdm2iqb5qwkfcrv2sk3nns3hhfqzs2v9mxmha";
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
