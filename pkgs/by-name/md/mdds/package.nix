{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  boost,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mdds";
  version = "2.1.1";

  src = fetchFromGitLab {
    owner = "mdds";
    repo = "mdds";
    rev = finalAttrs.version;
    hash = "sha256-a412LpgDiYM8TMToaUrTlHtblYS1HehzrDOwvIAAxiA=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  nativeCheckInputs = [ boost ];

  postInstall = ''
    mkdir -p $out/lib/
    mv $out/share/pkgconfig $out/lib/
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/mdds/mdds";
    description = "Collection of multi-dimensional data structure and indexing algorithms";
    changelog = "https://gitlab.com/mdds/mdds/-/blob/${finalAttrs.version}/CHANGELOG";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
})
# TODO: multi-output
