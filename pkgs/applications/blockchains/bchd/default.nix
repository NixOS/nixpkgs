{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "bchd";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "gcash";
    repo = "bchd";
    rev = "v${version}";
    sha256 = "012alma773y8vkzplx4flh9zf0bkb8ia69phlfq4l97mbapcq213";
  };

  vendorSha256 = "047xpbykw2m0fgyiys4kynfxd18byyj92g6fbvfhbqayyjg8gkah";

  # Tests are disabled because they try to write files to absolute paths. (/var/...)
  doCheck = false;

  meta = with lib; {
    description = "An alternative full node bitcoin cash implementation written in Go (golang)";
    homepage = "https://bchd.cash";
    license = licenses.mit;
    maintainers = with maintainers; [ ilyakooo0 ];
  };
}
