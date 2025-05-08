{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "space2meta";
  version = "0.2.0";

  src = fetchFromGitLab {
    group = "interception";
    owner = "linux/plugins";
    repo = "space2meta";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MvpIe230I0TNzTO6ol1+DrpcFgqw0gF9Z22WMQLujb4=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://gitlab.com/interception/linux/plugins/space2meta";
    description = "space2meta is a plugin for interception-tools to convert space key to meta key";
    mainProgram = "space2meta";
    license = licenses.mit;
    maintainers = [ maintainers.vyp ];
    platforms = platforms.linux;
  };
})
