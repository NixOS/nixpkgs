{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  openssh,
}:

stdenv.mkDerivation {
  pname = "rdocker";
  version = "0-unstable-2018-07-17";

  src = fetchFromGitHub {
    owner = "dvddarias";
    repo = "rdocker";
    rev = "949377de0154ade2d28c6d4c4ec33b65ea813b5a";
    hash = "sha256-pK1o9O4tRQZ+7qpH2jWC7O9DRhPbBJAmdgQTEuBPj9c=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 rdocker.sh $out/bin/rdocker
  '';

  postInstall = ''
    wrapProgram $out/bin/rdocker \
      --prefix PATH : ${lib.makeBinPath [ openssh ]}
  '';

  meta = {
    description = "Securely control a remote docker daemon CLI using ssh forwarding, no SSL setup needed";
    mainProgram = "rdocker";
    homepage = "https://github.com/dvddarias/rdocker";
    maintainers = [ ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
