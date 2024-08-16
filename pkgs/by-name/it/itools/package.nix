{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, perl
, libitl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "itools";
  version = "1.1";

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ libitl perl ];

  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = "arabeyes-org";
    repo = "itools";
    rev = finalAttrs.version;
    hash = "sha256-DxTZaq2SlEmy9k7iAdjctpPkk+2rIaF+xEcfXj/ERWw=";
  };

  meta = {
    description = "Islamic command-line tools for prayer times and hijri dates";
    longDescription = ''
      The itools package is a set of user friendly applications utilizing Arabeyes' ITL library.

      The package addresses two main areas - hijri date and prayertime calculation. The package
      is envisioned to mimick the development of the underlying ITL library and is meant to
      always give the end-user a simple means to access its functions.
    '';
    homepage = "https://www.arabeyes.org/ITL";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ amyipdev ];
  };
})
