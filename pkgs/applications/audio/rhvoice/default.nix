{ stdenv, lib, pkgconfig, fetchFromGitHub, scons, python, glibmm, libao
}:

stdenv.mkDerivation rec {
  name = "rhvoice-${version}";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "Olga-Yakovleva";
    repo = "RHVoice";
    rev = version;
    sha256 = "1gk5z1v7g7xg1dvc2qfa0ljgma8s96njg2k70rsnr3s1wsrgvqk7";
  };

  nativeBuildInputs = [
    scons pkgconfig
  ];

  buildInputs = [
    python glibmm libao
  ];

  # SConstruct patch
  #     Scons creates an independent environment that assumes standard POSIX paths.
  #     The patch is needed to push the nix environment.
  #     - PATH
  #     - PKG_CONFIG_PATH, to find available (sound) libraries
  #     - RPATH, to link to the newly built libraries

  patches = [ ./honor_nix_environment.patch ];

  # Zip friendly timestamps
  #     Some data is being zipped. Zip can't handle files from 1970.

  postPatch = ''
    find "./" '!' -newermt '1980-01-01' -exec touch -d '1980-01-02' '{}' '+'
  '';

  buildPhase = ''
    scons prefix=$out
  '';

  installPhase = ''
    scons install
  ''; 

  meta = {
    description = "A free and open source speech synthesizer for Russian language and others";
    homepage = https://github.com/Olga-Yakovleva/RHVoice/wiki;
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ berce ];
    platforms = with lib.platforms; all;
  };
}
