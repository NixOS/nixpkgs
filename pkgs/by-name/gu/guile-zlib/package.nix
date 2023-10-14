{ stdenv
, lib
, fetchFromGitea
, autoreconfHook
, pkg-config
, guile
, texinfo
, zlib
}:

stdenv.mkDerivation rec {
  pname = "guile-zlib";
  version = "0.1.0";

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "guile-zlib";
    repo = "guile-zlib";
    rev = "v${version}";
    hash = "sha256-+5tdp4WcnVuhfMwkr8t3Jd6/U539X5Ys9Pgzy79F4cY=";
  };

  strictDeps = true;
  nativeBuildInputs = [ autoreconfHook guile pkg-config texinfo ];
  buildInputs = [ guile ];
  propagatedBuildInputs = [ zlib ];
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  doCheck = true;

  meta = with lib; {
    description =
      "Guile-zlib is a GNU Guile library providing bindings to zlib";
    homepage = "https://notabug.org/guile-zlib/guile-zlib";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = guile.meta.platforms;
  };
}
