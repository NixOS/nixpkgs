{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "esp-generate";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "esp-generate";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-cSwTdUP3N19zzf6ecODCCc64jSmGq139UxUyevBQ3No=";
  };

  cargoHash = "sha256-z9Tq6N1xPon+BPfdPnwg7XP7Pn3rPug9xxqS/MrtBMk=";
=======
    hash = "sha256-OQUBX0hZNEgMpBttWZDXI/eoOlxVfY57oZqn3YKNZ0o=";
  };

  cargoHash = "sha256-Sf37qp1TBCabgKIExs9biqvdN+KtIBPGeokLMovjM68=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Template generation tool to create no_std applications targeting Espressif's chips";
    homepage = "https://github.com/esp-rs/esp-generate";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = [ lib.maintainers.eymeric ];
  };
}
