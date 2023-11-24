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
  vendorHash = "sha256-6cpHDwnxdc/9YPj77JVuT5ZDFjKkF6nBX4RgZr/9fFY=";

  # tests try to access the internet to scrape websites
  doCheck = false;

  meta = with lib; {
    description = "A tool for converting websites to rss/atom feeds";
    homepage = "https://git.sr.ht/~ghost08/ratt";
    license = licenses.mit;
    maintainers = with maintainers; [ kmein ];
  };
}
