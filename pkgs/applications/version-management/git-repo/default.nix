{ lib, stdenv, fetchFromGitHub, makeWrapper
, python3, git, gnupg, less
}:

stdenv.mkDerivation rec {
  pname = "git-repo";
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = "android";
    repo = "tools_repo";
    rev = "v${version}";
    sha256 = "sha256-D6gh14XOZ6Fjypfhg9l5ozPhyf6u6M0Wc8HdagdPM/Q=";
  };

  patches = [ ./import-ssl-module.patch ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  postPatch = ''
    substituteInPlace repo --replace \
      'urllib.request.urlopen(url)' \
      'urllib.request.urlopen(url, context=ssl.create_default_context())'
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp repo $out/bin/repo
  '';

  # Important runtime dependencies
  postFixup = ''
    wrapProgram $out/bin/repo --prefix PATH ":" \
      "${lib.makeBinPath [ git gnupg less ]}"
  '';

  meta = with lib; {
    description = "Android's repo management tool";
    longDescription = ''
      Repo is a Python script based on Git that helps manage many Git
      repositories, does the uploads to revision control systems, and automates
      parts of the development workflow. Repo is not meant to replace Git, only
      to make it easier to work with Git.
    '';
    homepage = "https://android.googlesource.com/tools/repo";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
