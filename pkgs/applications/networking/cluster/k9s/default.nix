{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k9s";
  version = "0.7.13";

  src = fetchFromGitHub {
    owner = "derailed";
    repo = "k9s";
    rev = version;
    sha256 = "0wsj6wc2qi5708cg47l2qblq1cg8fcwxdygpkayib9hapx6lc6f8";
  };

  modSha256 = "1ia9wx6yd9mdr981lcw58xv39iqzz25r03bmn1c6byxmq2xpcjq8";


  meta = with stdenv.lib; {
    description = "Kubernetes CLI To Manage Your Clusters In Style.";
    homepage = https://github.com/derailed/k9s;
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih ];
  };
}
