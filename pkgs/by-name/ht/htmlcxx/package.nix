{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "htmlcxx";
  version = "0.87";

  src = fetchurl {
    url = "mirror://sourceforge/htmlcxx/v${finalAttrs.version}/htmlcxx-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-XTj5OM9N+aKYpTRq8nGV//q/759GD8KgIjPLz6j8dcg=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libiconv ];
  patches = [
    ./ptrdiff.patch
    ./c++17.patch
  ];

  meta = {
    homepage = "https://htmlcxx.sourceforge.net/";
    description = "Simple non-validating css1 and html parser for C++";
    mainProgram = "htmlcxx";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.all;
  };
})
