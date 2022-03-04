{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hcl2json";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "tmccombs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Xr94Bq3w2j+hUoGy1mSLy3WCQiwrfS/5IL6i6CwKiPs=";
  };

  vendorSha256 = "sha256-Mz97GBxx/7oFjW6u5DG6JhvPRzn+hqtfqHdYv47L898=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Convert hcl2 to json";
    homepage = "https://github.com/tmccombs/hcl2json";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
