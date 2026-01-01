{
  lib,
  stdenv,
  fetchFromGitHub,
  docbook_xsl,
  libxslt,
  meson,
  ninja,
  pkg-config,
  bash-completion,
  libcap,
  libselinux,
}:

stdenv.mkDerivation rec {
  pname = "bubblewrap";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "bubblewrap";
    rev = "v${version}";
    hash = "sha256-8IDMLQPeO576N1lizVudXUmTV6hNOiowjzRpEWBsZ+U=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    substituteInPlace tests/libtest.sh \
      --replace "/var/tmp" "$TMPDIR"
  '';

  nativeBuildInputs = [
    docbook_xsl
    libxslt
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    bash-completion
    libcap
    libselinux
  ];

  # incompatible with Nix sandbox
  doCheck = false;

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/containers/bubblewrap/releases/tag/${src.rev}";
    description = "Unprivileged sandboxing tool";
    homepage = "https://github.com/containers/bubblewrap";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    changelog = "https://github.com/containers/bubblewrap/releases/tag/${src.rev}";
    description = "Unprivileged sandboxing tool";
    homepage = "https://github.com/containers/bubblewrap";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "bwrap";
  };
}
