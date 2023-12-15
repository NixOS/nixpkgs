{ buildGoModule
, lib
, fetchFromGitHub
}: buildGoModule rec {
  pname = "cntb";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "contabo";
    repo = "cntb";
    rev = "v${version}";
    hash = "sha256-bvWNcEUSSHEk8fwwPdowATGEHIAj+TN8Z+A156sPVtA=";
    # docs contains two files with the same name but different cases,
    # this leads to a different hash on case insensitive filesystems (e.g. darwin)
    postFetch = ''
      rm -rf $out/openapi/docs
    '';
  };

  subPackages = [ "." ];

  vendorHash = "sha256-++y2C3jYuGZ0ovRFoxeqnx7S9EwoOZBJ5zxeLGWjkqc=";

  meta = with lib; {
    description = "CLI tool for managing your products from Contabo like VPS and VDS";
    homepage = "https://github.com/contabo/cntb";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aciceri ];
  };
}
