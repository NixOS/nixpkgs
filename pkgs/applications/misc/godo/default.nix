{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "godo";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "rsHalford";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-82D51zWt9FlpqR69zhzZHn8v+xAwnHdxooM15oJLNd4=";
  };

  vendorSha256 = "sha256-jdAaHsOREHRAv9/CuEy6UVBjROwC1sZ9MTgvOsHW//I=";

  meta = with lib; {
    description = "A command line todo list application";
    homepage = "https://github.com/rsHalford/godo";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rsHalford ];
    platforms = platforms.linux;
    changelog = "https://github.com/rsHalford/godo/blob/v${version}/CHANGELOG.md";
  };
}
