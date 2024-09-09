{ buildGoModule, fetchFromSourcehut, lib }:
buildGoModule rec {
  pname = "ratt";
  version = "unstable-2023-02-12";

  src = fetchFromSourcehut {
    owner = "~ghost08";
    repo = "ratt";
    rev = "ed1a675685b9d86d6602e168199ba9b4260f5f06";
    hash = "sha256-HfS97Lxt6FAj/2/WAzLI06F/h6TP5m2lHHOTAs8XNFY=";
  };

  proxyVendor = true;
  vendorHash = "sha256-L8mDs9teQJW6P3dhKSLfzbpA7kzhJk61oR2q0ME+u0M=";

  # tests try to access the internet to scrape websites
  doCheck = false;

  meta = with lib; {
    description = "Tool for converting websites to rss/atom feeds";
    homepage = "https://git.sr.ht/~ghost08/ratt";
    license = licenses.mit;
    maintainers = with maintainers; [ kmein ];
    mainProgram = "ratt";
  };
}
