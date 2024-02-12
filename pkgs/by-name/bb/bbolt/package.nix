{ buildGoModule, fetchFromGitHub, lib }:
buildGoModule rec {
  pname = "bbolt";
  version = "1.3.8";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PMJaBSaviPv/ZdUkgqMRfGTOwkR7OZwJ+fecxsqFTyc=";
  };

  subPackages = [ "cmd/bbolt" ];

  vendorHash = "sha256-QZcNDGFmEDWivIxGcgM8K4DjpETJmhWpNT7oDlfV2pc=";

  meta = with lib; {
    homepage = "https://github.com/etcd-io/${pname}";
    license = licenses.mit;
    maintainers = with maintainers; [ bouk ];
  };
}
