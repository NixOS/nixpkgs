{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k9s";
  version = "0.23.10";

  src = fetchFromGitHub {
    owner  = "derailed";
    repo   = "k9s";
    rev    = "v${version}";
    sha256 = "0nfgi67ja36mymhcyh4902680pkfnk4g8j8nbajksx9nfp53n91v";
  };

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/derailed/k9s/cmd.version=${version}
      -X github.com/derailed/k9s/cmd.commit=${src.rev}
  '';

  vendorSha256 = "116aidry55917ays7rn5r5kj17nbgb9qi16bplml9kxfkjv072kz";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Kubernetes CLI To Manage Your Clusters In Style";
    homepage = "https://github.com/derailed/k9s";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih markus1189 ];
  };
}
