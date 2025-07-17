{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  openssh,
}:

stdenv.mkDerivation {
  pname = "rdocker";
  version = "unstable-2018-07-17";

  src = fetchFromGitHub {
    owner = "dvddarias";
    repo = "rdocker";
    rev = "949377de0154ade2d28c6d4c4ec33b65ea813b5a";
    sha256 = "1mwg9zh144q4fqk9016v2d347vzch8sxlixaxrz0ci9dxvs6ibd4";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 rdocker.sh $out/bin/rdocker
  '';

  postInstall = ''
    wrapProgram $out/bin/rdocker \
      --prefix PATH : ${lib.makeBinPath [ openssh ]}
  '';

  meta = with lib; {
    description = "Securely control a remote docker daemon CLI using ssh forwarding, no SSL setup needed";
    mainProgram = "rdocker";
    homepage = "https://github.com/dvddarias/rdocker";
    maintainers = [ lib.maintainers.pneumaticat ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
