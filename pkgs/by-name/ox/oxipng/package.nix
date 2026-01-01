{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
<<<<<<< HEAD
  version = "10.0.0";
=======
  version = "9.1.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "oxipng";

  # do not use fetchCrate (only repository includes tests)
  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = "oxipng";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-c8NNTO+6GuFb5BBPpdyDSHbtmojq+9ceOic54Zq3nwE=";
  };

  cargoHash = "sha256-YStZ2j2gjC5uVUnHaQIk6xtSbnPm0IoNONRr/nFOOUg=";
=======
    hash = "sha256-UjiGQSLiUMuYm62wF7Xwhp2MRzCaQ9pbBBkvHnuspVw=";
  };

  cargoHash = "sha256-sdhyxJDUlb6+SJ/kvfqsplHOeCEbA3ls66eur3eeVVA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # don't require qemu for aarch64-linux tests
  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "Multithreaded lossless PNG compression optimizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dywedir ];
    mainProgram = "oxipng";
  };
}
