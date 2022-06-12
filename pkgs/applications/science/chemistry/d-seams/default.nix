{ clangStdenv, fetchFromGitHub, catch2, rang, fmt, libyamlcpp, cmake
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

  nativeBuildInputs = [ cmake lua luaPackages.luafilesystem ];
  buildInputs = [ fmt rang libyamlcpp eigen catch2 boost gsl liblapack blas ];

  meta = with lib; {
    description =
      "d-SEAMS: Deferred Structural Elucidation Analysis for Molecular Simulations";
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
