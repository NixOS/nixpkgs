{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "deadnix";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "astro";
    repo = "deadnix";
    rev = "v${version}";
    hash = "sha256-xaaXGzTd+t1GjD2KpiS/c8acv6bXufv/lTN+ACRGVJw=";
  };

  cargoHash = "sha256-14onbdsactPJ27GTzG+culsdnwHvGdDXwBD9ZMq192Q=";

  meta = with lib; {
    description = "Find and remove unused code in .nix source files";
    homepage = "https://github.com/astro/deadnix";
    license = licenses.gpl3Only;
    mainProgram = "deadnix";
    maintainers = with maintainers; [ astro ];
  };
}
