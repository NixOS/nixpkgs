{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "psitop";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jamespwilliams";
    repo = "psitop";
    rev = version;
    hash = "sha256-C8WEbA7XXohKFz7QgII0LPU1eJ4Z7CSlmEOamgo4wQI=";
  };

  vendorHash = "sha256-oLtKpBvTsM5TbzfWIDfqgb7DL5D3Mldu0oimVeiUeSc=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Top for /proc/pressure";
    homepage = "https://github.com/jamespwilliams/psitop";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
