{ lib
, stdenv
, eigen
, fetchFromGitHub
, cmake
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opengv";
  version = "0-unstable-2020-08-06";

  src = fetchFromGitHub {
    owner = "laurentkneip";
    repo = "opengv";
    rev = "91f4b19c73450833a40e463ad3648aae80b3a7f3";
    hash = "sha256-LfnylJ9NCHlqjT76Tgku4NwxULJ+WDAcJQ2lDKGWSI4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    eigen
  ];

  meta = {
    description = "Collection of computer vision methods for solving geometric vision problems";
    homepage = "https://github.com/laurentkneip/opengv";
    license = lib.licenses.bsd2;
    longDescription = ''OpenGV is a collection of computer vision methods for solving
        geometric vision problems. It contains absolute-pose, relative-pose,
        triangulation, and point-cloud alignment methods for the calibrated
        case. All problems can be solved with central or non-central cameras,
        and embedded into a random sample consensus or nonlinear optimization
        context. Matlab and Python interfaces are implemented as well. The link
        to the above pages also shows links to precompiled Matlab mex-libraries.
        Please consult the documentation for more information.'';
    maintainers = [ lib.maintainers.locochoco ];
    platforms = lib.platforms.all;
  };
})
