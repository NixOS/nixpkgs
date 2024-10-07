{
  lib,
  bobcat,
  fetchFromGitLab,
  fetchurl,
  flexcpp,
  icmake,
  stdenv,
  yodl,
}:

let
  gpl = fetchurl {
    url = "https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt";
    hash = "sha256-7a72Msu2Q+TnoiFxemxEGkwafJGObk1W3rw9hzmyM/Y=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bisoncpp";
  version = "6.04.00";

  src = fetchFromGitLab {
    name = "bisoncpp-sources-${finalAttrs.version}";
    domain = "gitlab.com";
    owner = "fbb-git";
    repo = "bisoncpp";
    rev = finalAttrs.version;
    hash = "sha256-lIsghqkj2Sg1MUFIY13KGPo9QHwrP2amphGBR2RcSSk=";
  };

  buildInputs = [ bobcat ];

  nativeBuildInputs = [
    flexcpp
    icmake
    yodl
  ];

  sourceRoot = "${finalAttrs.src.name}/bisonc++";

  strictDeps = true;

  postPatch = ''
    substituteInPlace INSTALL.im --replace-fail /usr $out
    patchShebangs .
    substituteInPlace documentation/manual/conditions/gpl.yo \
      --replace /usr/share/common-licenses/GPL ${gpl}    
    for file in $(find documentation -type f); do
      substituteInPlace "$file" --replace-warn /usr $out
    done
  '';

  buildPhase = ''
    runHook preBuild

    ./build program
    ./build man
    ./build manual

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ./build install x

    runHook postInstall
  '';

  meta = {
    homepage = "https://fbb-git.gitlab.io/bisoncpp/";
    description = "Parser generator like bison, but it generates C++ code";
    license = lib.licenses.gpl2Plus;
    mainProgram = "bisonc++";
    maintainers = with lib.maintainers; [ raskin AndersonTorres ];
    platforms = lib.platforms.all;
  };
})
