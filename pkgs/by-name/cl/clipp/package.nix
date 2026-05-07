{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clipp";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "muellan";
    repo = "clipp";
    rev = "v${finalAttrs.version}";
    sha256 = "0rq80ba2krwzvcg4r2g1al88453c7lz6ziri2s1ygv8inp9r775s";
  };

  installPhase = ''
    mkdir -p $out/share/pkgconfig
    cp -r include $out/
    substitute ${./clipp.pc} $out/share/pkgconfig/clipp.pc \
      --subst-var out \
      --subst-var pname \
      --subst-var version
  '';

  meta = {
    description = "Easy to use, powerful and expressive command line argument handling for C++11/14/17";
    homepage = "https://github.com/muellan/clipp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xbreak ];
    platforms = with lib.platforms; all;
  };
})
