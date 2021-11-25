{ buildGoModule, fetchFromSourcehut, lib }:

buildGoModule rec {
  pname = "openring";
  version = "unstable-2021-06-28";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = pname;
    rev = "e566294050776355ca0d3bfd7a1f6f70767cd08b";
    sha256 = "sha256-h9Tout3KGiv6jbq9Ui3crb5NdTOHcn7BIy+aPoWG5sM=";
  };

  vendorSha256 = "sha256-BbBTmkGyLrIWphXC+dBaHaVzHuXRZ+4N/Jt2k3nF7Z4=";

  # The package has no tests.
  doCheck = false;

  meta = with lib; {
    description = "A webring for static site generators";
    homepage = "https://git.sr.ht/~sircmpwn/openring";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
