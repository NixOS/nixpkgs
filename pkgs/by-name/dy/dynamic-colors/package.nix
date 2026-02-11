{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dynamic-colors";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "peterhoeg";
    repo = "dynamic-colors";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-jSdwq9WwYZP8MK6z7zJa0q93xfanr6iuvAt8YQkQxxE=";
  };

  PREFIX = placeholder "out";

  postPatch = ''
    substituteInPlace bin/dynamic-colors \
      --replace /usr/share/dynamic-colors $out/share/dynamic-colors
  '';

  meta = {
    description = "Change terminal colors on the fly";
    homepage = "https://github.com/peterhoeg/dynamic-colors";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.unix;
    mainProgram = "dynamic-colors";
  };
})
