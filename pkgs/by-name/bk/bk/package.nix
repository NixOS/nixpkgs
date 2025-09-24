{
  fetchCrate,
  go-md2man,
  installShellFiles,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "bk";
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-rSMvx/zUZqRRgj48TVVG7RwQT8e70m0kertRJysDY4Y=";
  };

  cargoHash = "sha256-i62vUvR/iX0zKD29WsIvlcn49lcFvv2uN05oTexvPMc=";

  nativeBuildInputs = [
    go-md2man
    installShellFiles
  ];

  postBuild = ''
    sed -i '$ a # Source and further info' README.md
    sed -i '$ a https://github.com/aeosynth/bk' README.md
    go-md2man -in README.md -out bk.1
  '';

  postInstall = ''
    installManPage bk.?
  '';

  meta = with lib; {
    homepage = "https://github.com/aeosynth/bk";
    description = "Terminal epub reader written in rust";
    license = licenses.mit;
    maintainers = with maintainers; [ vuimuich ];
    mainProgram = "bk";
  };
}
