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
  gpl3PlusText = fetchurl {
    url = "https://www.gnu.org/licenses/gpl-3.0.txt";
    hash = "sha256-OXLcl0T2SZ8Pmy2/dmlvKuetivmyPd5m1q+Gyd+zaYY=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bisoncpp";
  version = "6.09.00";

  src = fetchFromGitLab {
    name = "bisoncpp-sources-${finalAttrs.version}";
    domain = "gitlab.com";
    owner = "fbb-git";
    repo = "bisoncpp";
    rev = finalAttrs.version;
    hash = "sha256-N3MiS4li1wQFDFr01fpXs3yH/Njjtd/OUHQsekiNjks=";
  };

  patches = [
    # Self-explaining, I think
    ./0000-parameterize-license-file.patch
  ];

  patchFlags = [
    # Because I changed the sourceRoot and the patch was written for the
    # original root
    "-p2"
  ];

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
    license_file=${gpl3PlusText} substituteAllInPlace documentation/manual/conditions/gpl.yo
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
    license = lib.licenses.gpl3Plus;
    mainProgram = "bisonc++";
    maintainers = with lib.maintainers; [
      raskin
      AndersonTorres
    ];
    platforms = lib.platforms.all;
  };
})
