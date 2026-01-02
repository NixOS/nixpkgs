{
  lib,
  stdenv,
  copyPkgconfigItems,
  fetchFromGitHub,
  makePkgconfigItem,
  pkg-config,
  SDL,
  SDL_image,
  SDL_mixer,
  SDL_net,
  SDL_ttf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sparrow3d";
  version = "unstable-2020-10-06";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "theZiz";
    repo = "sparrow3d";
    rev = "2033349d7adeba34bda2c442e1fec22377471134";
    hash = "sha256-28j5nbTYBrMN8BQ6XrTlO1D8Viw+RiT3MAl99BAbhR4=";
  };

  pkgconfigItems = [
    (makePkgconfigItem rec {
      name = "sparrow3d";
      inherit (finalAttrs) version;
      inherit (finalAttrs.meta) description;

      cflags = [ "-isystem${variables.includedir}" ];
      libs = [
        "-L${variables.libdir}"
        "-lsparrow3d"
        "-lsparrowNet"
        "-lsparrowSound"
      ];
      variables = rec {
        prefix = "@dev@";
        exec_prefix = "@out@";
        includedir = "${prefix}/include";
        libdir = "${exec_prefix}/lib";
      };
    })
  ];

  nativeBuildInputs = [
    copyPkgconfigItems
    pkg-config
  ];

  propagatedBuildInputs = [
    (lib.getDev SDL)
    SDL_image
    SDL_ttf
    SDL_mixer
    SDL_net
  ];

  postConfigure = ''
    NIX_CFLAGS_COMPILE=$(pkg-config --cflags SDL_image SDL_ttf SDL_mixer SDL_net)
  '';

  buildFlags = [ "dynamic" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp libsparrow{3d,Net,Sound}.so $out/lib

    mkdir -p $dev/include
    cp sparrow*.h $dev/include

    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    make all_no_static
    ./testfile.sh

    runHook postCheck
  '';

  meta = {
    homepage = "https://github.com/theZiz/sparrow3d";
    description = "Software renderer for different open handhelds like the gp2x, wiz, caanoo and pandora";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ colinsane ];
    platforms = lib.platforms.linux;
  };
})
