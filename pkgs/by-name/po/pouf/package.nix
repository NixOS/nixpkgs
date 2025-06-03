{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "pouf";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "mothsart";
    repo = "pouf";
    rev = version;
    hash = "sha256-tW86b9a7u1jyfmHjwjs+5DaUujRZH+VhGQsj0CBj0yk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cgRf8zpl2hOhaGew4dwzuwdy0+7wSvMtYN3llVi3uYw=";

  postInstall = "make PREFIX=$out copy-data";

  meta = with lib; {
    description = "CLI program for produce fake datas";
    homepage = "https://github.com/mothsart/pouf";
    changelog = "https://github.com/mothsart/pouf/releases/tag/${version}";
    maintainers = with maintainers; [ mothsart ];
    license = with licenses; [ mit ];
    mainProgram = "pouf";
  };
}
