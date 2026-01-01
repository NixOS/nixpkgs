{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gospider";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "jaeles-project";
    repo = "gospider";
    rev = "v${version}";
    sha256 = "sha256-1EnKheHaS1kxw0cjxCahT3rUWBXiqxjKefrDBI2xIvY=";
  };

  vendorHash = "sha256-egjjSEZH8F6UMbnkz3xytIzdW/oITB3RL1ddxrmvSZM=";

  # tests require internet access and API keys
  doCheck = false;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Fast web spider written in Go";
    mainProgram = "gospider";
    longDescription = ''
      GoSpider is a fast web crawler that parses sitemap.xml and robots.txt file.
      It can generate and verify link from JavaScript files, extract URLs from
      various sources and can detect subdomains from the response source.
    '';
    homepage = "https://github.com/jaeles-project/gospider";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
