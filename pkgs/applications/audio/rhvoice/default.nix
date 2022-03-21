{ stdenv, lib, pkg-config, fetchFromGitHub, sconsPackages
, glibmm, libpulseaudio, libao }:

let
  version = "unstable-2018-02-10";
in stdenv.mkDerivation {
  pname = "rhvoice";
  inherit version;

  src = fetchFromGitHub {
    owner = "Olga-Yakovleva";
    repo = "RHVoice";
    rev = "7a25a881b0465e47a12d8029b56f3b71a1d02312";
    sha256 = "1gkrlmv7msh9qlm0gkjqpl9gswghpclfdwszr1p85v8vk6m63v0b";
  };

  nativeBuildInputs = [
    sconsPackages.scons_3_1_2 pkg-config
  ];

  buildInputs = [
    glibmm libpulseaudio libao
  ];

  # SConstruct patch
  #     Scons creates an independent environment that assumes standard POSIX paths.
  #     The patch is needed to push the nix environment.
  #     - PATH
  #     - PKG_CONFIG_PATH, to find available (sound) libraries
  #     - RPATH, to link to the newly built libraries

  patches = [ ./honor_nix_environment.patch ];

  meta = {
    description = "A free and open source speech synthesizer for Russian language and others";
    homepage = "https://github.com/Olga-Yakovleva/RHVoice/wiki";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ berce ];
    platforms = with lib.platforms; all;
  };
}
