{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cordless";
  version = "2020-11-22";

  src = fetchFromGitHub {
    owner = "Bios-Marcel";
    repo = pname;
    rev = version;
    hash = "sha256-nOHLI0N4d8aC7KaWdLezSpVU1DS1fkfW5UO7cVYCbis=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-XnwTqd19q+hOJZsfnFExiPDbg4pzV1Z9A6cq/jhcVgU=";

  meta = with lib; {
    homepage = "https://github.com/Bios-Marcel/cordless";
    description = "Discord terminal client";
    license = licenses.bsd3;
    maintainers = with maintainers; [ colemickens ];
  };
}
