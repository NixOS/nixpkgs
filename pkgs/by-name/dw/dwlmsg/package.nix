{
  fetchFromGitea,
  pkg-config,
  stdenv,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dwlmsg";
  version = "git";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "notchoc";
    repo = "dwlmsg";
    rev = "3fc9780f4e";
    hash = "sha256-LTrWb9IxGvm9yUy47+Om9V5GbLygDcEAbVAExGWgFQw=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    wayland
  ];

  outputs = [
    "out"
  ];

  makeFlags = [
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
    "PREFIX=$(out)"
  ];

  strictDeps = true;

  # required for whitespaces in makeFlags
  __structuredAttrs = true;

})
