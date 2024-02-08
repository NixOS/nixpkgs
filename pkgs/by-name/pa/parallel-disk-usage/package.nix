{ lib
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "parallel-disk-usage";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "KSXGitHub";
    repo = pname;
    rev = version;
    hash = "sha256-kOMbVKwnGh47zZkWAWkctfTIE5F8oeSnAgJEU/OdsQc=";
  };

  cargoHash = "sha256-Jk9sNvApq4t/FoEzfjlDT2Td5sr38Jbdo6RoaOVQJK8=";

  checkFlags = [
    # test example is ordered wrong on some systems
    # https://github.com/KSXGitHub/parallel-disk-usage/issues/251
    "--skip=multiple_names"
  ];

  meta = with lib; {
    description = "Highly parallelized, blazing fast directory tree analyzer";
    homepage = "https://github.com/KSXGitHub/parallel-disk-usage";
    license = licenses.asl20;
    maintainers = [maintainers.peret];
    mainProgram = "pdu";
  };
}
