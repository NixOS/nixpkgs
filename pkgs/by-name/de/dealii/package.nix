{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dealii";
  version = "9.7.1";

  src = fetchFromGitHub {
    owner = "dealii";
    repo = "dealii";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hy7Z9DUcSv/k5UU5TOfYzCIEiKXBZZEUrRnJ7jN1gus=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost ];

  meta = {
    homepage = "https://dealii.org/";
    description = "C++ software library supporting the creation of finite element codes";
    longDescription = ''
      deal.II is a C++ program library targeted at the computational solution of
      partial differential equations using adaptive finite elements.
      It uses state-of-the-art programming techniques to offer you a modern interface
      to the complex data structures and algorithms required.
    '';
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ neural-blade ];
    platforms = lib.platforms.unix;
  };
})
