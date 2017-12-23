{ stdenv, lib, pkgconfig, fetchFromGitHub, scons, python, glibmm, libao
}:

stdenv.mkDerivation rec {
  name = "rhvoice";
  #version = "2017-09-24";
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

  # SConstruct patches
  # 1. Scons creates an independent environment that assumes standard POSIX paths.
  #    The patch is needed to push the nix environment.
  #    - PATH
  #    - PKG_CONFIG_PATH, to find available (sound) libraries
  #    - RPATH, to link to the newly built libraries
  # 2. Some data is being zipped. Zip can't handle files from 1970.
  #
  postPatch = ''
    substituteInPlace SConstruct --replace 'env=Environment(**env_args)' 'env=Environment(**env_args)
        env.PrependENVPath("PATH", os.environ["PATH"])
        env["ENV"]["PKG_CONFIG_PATH"]=os.environ["PKG_CONFIG_PATH"]
            '
    substituteInPlace SConstruct --replace 'else:
            env["BUILDDIR"]=BUILDDIR
    ' 'else:
            env["BUILDDIR"]=BUILDDIR
            env["RPATH"]="'$out'/lib"
    '
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
