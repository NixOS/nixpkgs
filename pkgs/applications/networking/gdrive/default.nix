{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "gdrive";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "prasmussen";
    repo = "gdrive";
    rev = version;
    hash = "sha256-2dJmGFHfGSroucn4WgiV2NExBs5wtMDe2kX1jDBwbRs=";
  };

  deleteVendor = true;
  vendorHash = "sha256-sHNP1YwnZYu0UfgLx5+gxJmesY8Brt7rr9cptlyk9Bk=";

  patches = [
    # Add Go Modules support
    (fetchpatch {
      url = "https://github.com/prasmussen/gdrive/pull/585/commits/faa6fc3dc104236900caa75eb22e9ed2e5ecad42.patch";
      hash = "sha256-W8o2ZfhQFJISHfPavjx9sw5UB6xOZ7qRW4L0bHNddS8=";
    })
  ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/prasmussen/gdrive";
    description = "A command line utility for interacting with Google Drive";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.rzetterberg ];
  };
}
