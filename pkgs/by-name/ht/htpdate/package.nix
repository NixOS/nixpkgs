{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.0.2";
  pname = "htpdate";

  src = fetchFromGitHub {
    owner = "twekkel";
    repo = "htpdate";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-aDir0e/itYxo0wgKIyT2chEVyXgz6nd2JOuyo7Yq/js=";
  };

  makeFlags = [
    "prefix=$(out)"
  ];

  meta = {
    description = "Utility to fetch time and set the system clock over HTTP";
    homepage = "https://github.com/twekkel/htpdate";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ julienmalka ];
    mainProgram = "htpdate";
  };
})
