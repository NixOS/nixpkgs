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
  version = "3.0.0";

  src = fetchFromGitLab {
    owner = "mdds";
    repo = "mdds";
    rev = finalAttrs.version;
    hash = "sha256-XIfrbnjY3bpnbRBnE44dQNJm3lhL0Y1Mm0sayh3T2aY=";
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
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
})
# TODO: multi-output
