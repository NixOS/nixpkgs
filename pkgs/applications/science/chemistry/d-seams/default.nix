{ clangStdenv, fetchFromGitHub, fetchpatch, catch2, rang, fmt, yaml-cpp, cmake
, eigen, lua, luaPackages, liblapack, blas, lib, boost, gsl }:

clangStdenv.mkDerivation rec {
  version = "1.0.1";
  pname = "d-SEAMS";

  src = fetchFromGitHub {
    owner = "d-SEAMS";
    repo = "seams-core";
    rev = "v${version}";
    sha256 = "03zhhl9vhi3rhc3qz1g3zb89jksgpdlrk15fcr8xcz8pkj6r5b1i";
  };

  patches = [
    (fetchpatch {
      name = "use_newer_cxxopts_which_builds_with_clang11.patch";
      url = "https://github.com/d-SEAMS/seams-core/commit/f6156057e43d0aa1a0df9de67d8859da9c30302d.patch";
      hash = "sha256-PLbT1lqdw+69lIHH96MPcGRjfIeZyb88vc875QLYyqw=";
    })
  ];
  nativeBuildInputs = [ cmake lua luaPackages.luafilesystem ];
  buildInputs = [ fmt rang yaml-cpp eigen catch2 boost gsl liblapack blas ];

  meta = with lib; {
    description =
      "d-SEAMS: Deferred Structural Elucidation Analysis for Molecular Simulations";
    mainProgram = "yodaStruct";
    longDescription = ''
      d-SEAMS, is a free and open-source postprocessing engine for the analysis
      of molecular dynamics trajectories, which is specifically able to
      qualitatively classify ice structures in both strong-confinement and bulk
      systems. The engine is in C++, with extensions via the Lua scripting
      interface.
    '';
    homepage = "https://dseams.info";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.HaoZeke ];
  };
}
