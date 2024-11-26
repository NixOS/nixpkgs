{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gh-i";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "gennaro-tedesco";
    repo = "gh-i";
    rev = "v${version}";
    hash = "sha256-fW9T7B/97kI8zjaTvJHOkEUGVVM+ysOxZzqVNeOfVkc=";
  };

  vendorHash = "sha256-TSl+7N3W3BeW8UWxUdTv3cob2P7eLvO+80BLqcbhanQ=";

  ldflags = [ "-s" ];

  meta = with lib; {
    description = "Search github issues interactively";
    changelog = "https://github.com/gennaro-tedesco/gh-i/releases/tag/v${version}";
    homepage = "https://github.com/gennaro-tedesco/gh-i";
    license = licenses.asl20;
    maintainers = with maintainers; [ phanirithvij ];
    mainProgram = "gh-i";
  };
}
