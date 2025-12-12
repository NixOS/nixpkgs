{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "sourcemapper";
  version = "0-unstable-2024-03-22";

  src = fetchFromGitHub {
    owner = "denandz";
    repo = "sourcemapper";
    rev = "467916e59f9f28f2df3c2fb209db32dabd057c92";
    hash = "sha256-JuP8ElLyG+FynH0YYZqpZejbAwcCq5d9lj5hJYGW7+g=";
  };

  vendorHash = null;

  meta = {
    description = "Extract JavaScript source trees from Sourcemap files";
    homepage = "https://github.com/denandz/sourcemapper";
    license = lib.licenses.bsd3;
    mainProgram = "sourcemapper";
    maintainers = with lib.maintainers; [
      emilytrau
      crem
    ];
  };
}
