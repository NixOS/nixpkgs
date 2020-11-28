{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k9s";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner  = "derailed";
    repo   = "k9s";
    rev    = "v${version}";
    sha256 = "1b67a417b0914ccl7drdfd7bq1qsfkw9haqz4m5j96qb0l5p71w2";
  };

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/derailed/k9s/cmd.version=${version}
      -X github.com/derailed/k9s/cmd.commit=${src.rev}
  '';

  vendorSha256 = "01g50sfk0k7v60m3anfiq2w9pzl2wpa985s22ciq911h3fscka3f";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Kubernetes CLI To Manage Your Clusters In Style";
    homepage = "https://github.com/derailed/k9s";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih markus1189 ];
  };
}
