{ buildGoModule, fetchFromGitHub, stdenv }:

let
  pname = "osm-cli";
  version = "0.1.0";
  sha256 = "0hc63xvww4p4bqsq2ihz5in5ia9x7ibfa7ixd6fkxvdb1rbwxrx6";
  vendorSha256 = "03qy4gl9lii4amsfg2y4ib5xwg74gri601pkfa3c7jwc034xf5kf";
in buildGoModule {
  inherit pname version vendorSha256;

  src = fetchFromGitHub {
    inherit sha256;

    owner = "openservicemesh";
    repo = "osm";
    rev = "v${version}";
  };

  subPackages = [ "cmd/cli" ];

  postInstall = ''
    mv $out/bin/cli $out/bin/osm
  '';

  meta = with stdenv.lib; {
    homepage = "https://openservicemesh.io";
    description = "The CLI for managing Open Service Mesh";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
