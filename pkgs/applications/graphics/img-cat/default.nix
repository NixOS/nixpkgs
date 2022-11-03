{ lib, buildGoModule, fetchFromGitHub, updateGolangSysHook }:

buildGoModule rec {
  pname = "imgcat";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "trashhalo";
    repo = "imgcat";
    rev = "v${version}";
    sha256 = "0x7a1izsbrbfph7wa9ny9r4a8lp6z15qpb6jf8wsxshiwnkjyrig";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-9AhYg258ry1rz3cRHbbjkNHKyE1NreQFV59gW+4ndHQ=";

  meta = with lib; {
    description = "A tool to output images as RGB ANSI graphics on the terminal";
    homepage = "https://github.com/trashhalo/imgcat";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
